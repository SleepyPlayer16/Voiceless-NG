	extends Sprite

var pos = Vector2()
var selected_option = 0
var has_pressed = false
var scriptt = preload("res://Scripts/transitionscript.gd")
var instance = scriptt.new() 
var timer = 0
var has_played = false
var has_pressed2electricboogaloo=false
var timer2 = 0
var screen = 0 # 0=main menu 1=options 2=calibration
var has_focus = true
var volume = 0
var canmove = 0
var console_focus = false
var charaSelectArrow = preload("res://sprites/menu/spr_character_selector.png")
var menuOptionSelectArrow = preload("res://sprites/menu/spr_option_selector.png")
var goToTutorial = false
onready var background = get_node("../spr_background")
onready var audiostream = get_node("../AudioStreamPlayer2")
onready var controller = get_node("../controls/Control")
onready var savedata = get_node("../MainMenuScreen")
onready var control_change = get_node("../controls/Control")
onready var menu_screen = get_node("../MainMenuScreen")
onready var characterSelectScreen = get_node("../CharacterSelectScreen")
onready var options_screen = get_node("../options")
onready var offset_screen = get_node("../VisualOffsetCalibrationScreen")
onready var volume_slider = get_node("../options/spr_volume_slider")
onready var consoleHandler = get_node("../ConsoleNode")
var console = preload("res://objects/Console.tscn")
onready var trainingtransition = get_node("../ColorRect2")
# Called when the node enters the scene tree for the first time.
func _ready():
	volume = savedata.data.user_data["volume"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	volume_slider.frame = savedata.data.user_data["vol_sprite_frame"]
	controller.control_mode = savedata.data.user_data["control_mode"]
	
	position.y = 56
	position.x = 232

	
func _process(_delta):
	if screen == 0:
		menuscreen_movement(_delta)
	elif screen == 1:
		optionscreen_movement(_delta)
	elif screen == 3: 
		characterScreen_movement(_delta)
		
func soundplay():
	var select_sound = AudioStreamPlayer.new()
	self.add_child(select_sound)
	select_sound.stream = load("res://sound_effect stuff/misc_menu_4.wav")
	select_sound.play()
	select_sound.set_volume_db(-15)
	yield (select_sound, "finished")
	select_sound.queue_free()

func soundplay1():
	var select_sound = AudioStreamPlayer.new()
	self.add_child(select_sound)
	select_sound.stream = load("res://sound_effect stuff/load.wav")
	select_sound.play()
	select_sound.set_volume_db(-15)
	yield (select_sound, "finished")
	select_sound.queue_free()

func negative():
	var select_sound = AudioStreamPlayer.new()
	self.add_child(select_sound)
	select_sound.stream = load("res://sound_effect stuff/sfx_cannotSelect.wav")
	select_sound.play()
	select_sound.set_volume_db(-5)
	yield (select_sound, "finished")
	select_sound.queue_free()	

func menuscreen_movement(delta):
	canmove+=1
	if selected_option > 2:
		selected_option = 0
	if selected_option < 0:
		selected_option = 2
	if canmove >=1:
		if has_pressed == false and console_focus == false:
			if Input.is_action_just_pressed("Console"):
				console_focus = true
				consoleHandler.open_console()
			if Input.is_action_just_pressed("ui_up"):
				soundplay()
				selected_option-=1
			if Input.is_action_just_pressed("ui_down"):
				soundplay()
				selected_option+=1
		if Input.is_action_just_pressed("confirm") and has_pressed == false and selected_option == 0 and console_focus == false:#PLAY SELECTED
			has_pressed2electricboogaloo=true
			screen = 3
			soundplay1()
			menu_screen.visible = false
			characterSelectScreen.visible = true
			selected_option = 0
			texture = charaSelectArrow
		if Input.is_action_just_pressed("confirm") and has_pressed == false and selected_option==2 and console_focus == false:##OPTIONS SELECTED
			soundplay1()
			menu_screen.visible = false
			options_screen.visible = true
			screen = 1#Changes focus to the options screen
			selected_option = 0
#			queue_free()
#			instance.free()
#			get_tree().quit()
		if Input.is_action_just_pressed("confirm") and has_pressed == false and selected_option==1 and console_focus == false:##OPTIONS SELECTED
			soundplay1()
			goToTutorial = true
			has_pressed = true
		if goToTutorial == true:
			trainingtransition.modulate.a += (0.05*delta)*60
			audiostream.realplayer.volume_db-=(0.5*delta)*60
			timer+=(1*delta)*60
			if timer  >= 120:
				get_tree().change_scene("res://Scenes/World_3/TrainingRoom.tscn")
	
		if selected_option == 0:
			position.y = lerp(position.y,0,((0.2*delta)*60))
			position.x = lerp(position.x,232,((0.2*delta)*60))
		if selected_option == 1:
			position.y = lerp(position.y,88,((0.2*delta)*60))
			position.x = lerp(position.x,296,((0.2*delta)*60))
		if selected_option == 2:
			position.y = lerp(position.y,200,((0.2*delta)*60))
			position.x = lerp(position.x,292,((0.2*delta)*60))

func characterScreen_movement(delta):
	if has_pressed == false:
		if Input.is_action_just_pressed("ui_right"):
			soundplay()
			selected_option+=1
		elif Input.is_action_just_pressed("ui_left"):
			soundplay()
			selected_option-=1

		match (selected_option):
			0:#Karu
				position.y = lerp(position.y,200,((0.2*delta)*60))
				position.x = lerp(position.x,-296,((0.2*delta)*60))		
				if Input.is_action_just_pressed("confirm"):
					soundplay1()
					savedata.data.user_data["selected_character"] = 1
					savedata.save_game()
					has_pressed = true
			1:#Liz
				
				position.y = lerp(position.y,200,((0.2*delta)*60))
				position.x = lerp(position.x,0,((0.2*delta)*60))
				
				if Input.is_action_just_pressed("confirm"):
					if savedata.data.user_data["liz_unlocked"] == true:		
						soundplay1()
						savedata.data.user_data["selected_character"] = 2
						savedata.save_game()
						has_pressed = true
					else:
						negative()
			2:#Froo
				position.y = lerp(position.y,200,((0.2*delta)*60))
				position.x = lerp(position.x,296,((0.2*delta)*60))		
				if Input.is_action_just_pressed("confirm"):
					soundplay1()
					savedata.data.user_data["selected_character"] = 3
					savedata.save_game()
					has_pressed = true
		if selected_option > 2:
			selected_option = 0
		if selected_option < 0:
			selected_option = 2
		if Input.is_action_just_pressed("back"):
			texture = menuOptionSelectArrow
			has_pressed = false
			selected_option = 0
			menu_screen.visible = true
			characterSelectScreen.visible = false
			screen = 0
			soundplay1()
	else:
		characterSelectScreen.transition_rect.modulate.a += (0.05*delta)*60
		audiostream.realplayer.volume_db-=(0.5*delta)*60
		timer+=(1*delta)*60
		if timer  >= 120:
			get_tree().change_scene("res://Scenes/World_1/World.tscn")
		visible = false

func optionscreen_movement(delta):
	if selected_option > 3:
		selected_option = 0
	if selected_option < 0:
		selected_option = 3
	#I apologize for what u're about to see
	if selected_option == 0:
		if Input.is_action_just_pressed("ui_left"):
			if volume_slider.frame != 21:
				volume-=1
				volume_slider.frame+=1
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
				savedata.data.user_data["volume"] = volume
				savedata.data.user_data["vol_sprite_frame"] = volume_slider.frame
				savedata.save_game()


			if volume_slider.frame == 21:
				volume = -180
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -180)
				savedata.data.user_data["volume"] = -180
				savedata.data.user_data["vol_sprite_frame"] = volume_slider.frame
				savedata.save_game()

		if Input.is_action_just_pressed("ui_right"):
			if volume_slider.frame == 0:
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
				savedata.data.user_data["volume"] = volume
				savedata.data.user_data["vol_sprite_frame"] = volume_slider.frame
				savedata.save_game()

			if volume_slider.frame != 0:
				volume+=1
				volume_slider.frame-=1
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
				savedata.data.user_data["volume"] = volume
				savedata.data.user_data["vol_sprite_frame"] = volume_slider.frame
				savedata.save_game()

			if volume_slider.frame == 20:
				volume = -20
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -20)
				savedata.data.user_data["volume"] = 0
				savedata.data.user_data["vol_sprite_frame"] = volume_slider.frame
				savedata.save_game()

	if has_pressed == false:
		if Input.is_action_just_pressed("ui_up"):
			soundplay()
			selected_option-=1
		if Input.is_action_just_pressed("ui_down"):
			soundplay()
			selected_option+=1
	if Input.is_action_just_pressed("confirm") and has_pressed == false and selected_option == 1:
		if control_change.control_mode == 0:
			control_change.control_mode = 1
			controller.should_save = true
			savedata.data.user_data["control_mode"] = control_change.control_mode
			savedata.save_game()
		else:
			control_change.control_mode = 0
			controller.should_save = true
			savedata.data.user_data["control_mode"] = control_change.control_mode
			savedata.save_game()
		soundplay1()
	if Input.is_action_just_pressed("confirm") and has_pressed == false and selected_option == 3:
		screen = 0
		selected_option = 0
		soundplay1()
		options_screen.visible = false
		menu_screen.visible = true
	if Input.is_action_just_pressed("back") and has_pressed == true and selected_option == 2:
		has_pressed = false
		selected_option = 0
		soundplay1()
		options_screen.visible = true
		offset_screen.visible = false
		visible = true

	if Input.is_action_just_pressed("confirm") and has_pressed == false and selected_option == 2:
		has_pressed = true
		soundplay1()
		options_screen.visible = false
		offset_screen.visible = true
		visible = false
		
	match selected_option:
		0:
			position.y = lerp(position.y,-112,((0.2*delta)*60))
			position.x = lerp(position.x,168,((0.2*delta)*60))
		1:
			position.y = lerp(position.y,-2,((0.2*delta)*60))
			position.x = lerp(position.x,288,((0.2*delta)*60))
		2:
			position.y = lerp(position.y,128,((0.2*delta)*60))
			position.x = lerp(position.x,152,((0.2*delta)*60))
		3:
			position.y = lerp(position.y,232,((0.2*delta)*60))
			position.x = lerp(position.x,152,((0.2*delta)*60))

func open_console():
	var id = console.instance()
	add_child(id)
