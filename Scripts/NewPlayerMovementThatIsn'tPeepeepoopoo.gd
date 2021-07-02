extends KinematicBody2D

var AAAAAAAAA = null
var path = "user://data.json"
var data = { }
var emit_checkpoint_particles = false
var state = null
var movement = Vector2()
var verticalMovement = Vector2()
var hsp = 0
var play_sfx = true
var character_number = null
var max_speed = 150
var max_fallSpeed = 350
var play_idle_once = false
var gravity = 18
var friccion = 15
var decel = 0.3
var jump_speed = null
var vsp = 0
var is_moving = false
var safepress = 0
var safepress2 = 0
var deltadeath
var finish_timer = 0
var can_act = true
var time = 0
var bpm = 0
var num = 0
var dedDone = false
var seconds = 0
var dir = 1
var amIinTheFuckinAir = false
var jump_power = 0
var jump_number = 0
var has_dashed = false
var dash_timer = 0
var antijumppress = false
var facing_front = 1
var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
var startingposx = null
var startingposy = null
var death_timer = 0
var recordyposition = null
var combo = -999999
var combo_break_tolerance = 60
var sign_timer = 0
var countdown = 180 #Ready go countdown
var goTex = preload("res://sprites/GUI/spr_go.png")
var particles = preload("res://objects/Checkpoint.tscn")
onready var blueblock = 0
onready var text_sign = $pressbtn
onready var animationPlayer = $AnimationPlayer #Las animaciones se cargan
onready var readygo = $CanvasLayer/ReadyGo
onready var transition_shit = $CanvasLayer/ColorRect

onready var inst_sign
onready var checkpoint_particles 
onready var checkpoint 
onready var actualcheckpoint
onready var rhythmind = get_node("../Rythm/rhythm_container/Sprite/AnimationPlayer")
onready var portalRed
onready var portalBlue
onready var timerpg = $CanvasLayer/TimerDisplay
onready var clock

enum{
	IDLE,
	MOVE,
	DASH,
	TRIP,
	DEATH,
	VICTORY,
	CONVERSATION
}

var char_karu = {
	character_number = 1,
	max_speed = 150,
	max_fallSpeed = 350,
	gravity = 18,
	friccion = 15,
	decel = 0.3,
	jump_speed = -250
}

var char_frog = {
	character_number = 3,
	max_speed = 142,
	max_fallSpeed = 350,
	gravity = 13,
	friccion = 10,
	decel = 0.1,
	jump_speed = -300
}

var char_liz = {
	character_number = 2,
	max_speed = 180,
	max_fallSpeed = 350,
	gravity = 13,
	friccion = 19,
	decel = 0.2,
	jump_speed = -225
}

var char_hang = {
	character_number = 4,
	max_speed = 170,
	max_fallSpeed = 350,
	gravity = 20,
	friccion = 21,
	decel = 0.2,
	jump_speed = -230
}


var character_data = {
	char_karu = char_karu,
	char_frog = char_frog,
	char_liz = char_liz
}

func _ready():
	bpm = get_node("../AudioStreamPlayer2/").actualbpm

	load_game()
	
	character_number = data.user_data["selected_character"]#1 for Karu, 2 for Frog, 3 for liz, 4 for Hang, 5 for Applesauce, 6 for Hazuki
	#print("What is the FUCKING current character??? = ",character_number)
	play_sfx = data.user_data["sfx_active"]
	if get_tree().current_scene.name == "menu":
		$Camera2D.current=false
		transition_shit.visible = false
		readygo.visible = false
		$Sprite.scale.x = 1
		$Sprite.scale.y = 1
		$CollisionShape2D.scale.x = 1
		$CollisionShape2D.scale.y = 1
	else:
		inst_sign = get_node("../Sign")
		checkpoint_particles = get_node("../Checkpoint/Particles2D")
		checkpoint = get_node("../Checkpoint/Sprite")
		actualcheckpoint = get_node("../Checkpoint")

	if get_tree().current_scene.name == "World3":
		portalBlue = get_node("../BluePortal")
		portalRed = get_node("../RedPortal")
		timerpg.enabled = true
		clock = get_node("../Clock")
	if get_tree().current_scene.name == "tutoiral":
		character_number = 1
	#If you want to add a custom character, Create a new Sprite and name it however you
	#want (example: MyCoolCharacter)
	#then, add a new AnimationPlayer to the Player node
	#and set up the animations for your character in there
	#(if you don't know how to this just look up a tutorial on youtube lol)
	#You gotta need ALL animations to be in the same image.
	#After that you can add your character's case below
	
	#If your custom character doesn't do anything complex code-wise, all you need to
	#do is add another number to the match below, set the other two character's 
	#visibility to false and set the one of your character to true
	#example:
	#	3:
	#		$Sprite.visible = false (this is karu)
	#		$FrogSprite.visible = false
	#		$MyCoolCharacter.visible = true
	#However, remember to make your character invisible in other character cases too
	#Oh and btw, for the character boppin their head to the beat animation, go to  
	#AudioStreamPlayer.gd there's info bout' that in there

	if character_number == 1:
		$Sprite.visible = true
		$FrogSprite.visible = false
		$Liz.visible = false

	elif character_number == 3:
			$Sprite.visible = false
			$FrogSprite.visible = true
			$Liz.visible = false

	else:
			$Sprite.visible = false
			$FrogSprite.visible = false
			$Liz.visible = true

	save_data("user://characters.dat", character_data)
	load_save("user://characters.dat")

	if character_number == 1:
		max_speed = character_data.char_karu.max_speed
		max_fallSpeed = character_data.char_karu.max_fallSpeed 
		gravity = character_data.char_karu.gravity
		friccion = character_data.char_karu.friccion
		decel = character_data.char_karu.decel
		jump_speed = character_data.char_karu.jump_speed
		$Line2D.default_color = Color( 255, 208, 49, 1 )
	elif character_number == 3:
			max_speed = character_data.char_frog.max_speed
			max_fallSpeed = character_data.char_frog.max_fallSpeed 
			gravity = character_data.char_frog.gravity
			friccion = character_data.char_frog.friccion
			decel = character_data.char_frog.decel
			jump_speed = character_data.char_frog.jump_speed
			$Line2D.default_color = Color( 23, 229, 65, 1 )
	else:
			max_speed = character_data.char_liz.max_speed
			max_fallSpeed = character_data.char_liz.max_fallSpeed 
			gravity = character_data.char_liz.gravity
			friccion = character_data.char_liz.friccion
			decel = character_data.char_liz.decel
			jump_speed = character_data.char_liz.jump_speed
			$Line2D.default_color = Color( 239, 49, 174, 1 )

	if get_tree().current_scene.name == "World2":
		var temp_fric = friccion
		var _temp_decel = decel
		if amIinTheFuckinAir == false:
			if character_number == 1:
				decel = 0.06
			else:
				decel = 0.06
		else:
			friccion = temp_fric
			_temp_decel = decel
	state = IDLE
	$Particles2D.emitting = false
	$Line2D.visible = false
func setup(World):
	bpm = World.bpm

func _physics_process(delta):#PHYSICS PROCESS AA A A A A h
	deltadeath = delta
	#Start the fookin countdown
	if get_tree().current_scene.name == "World3":
		if (timerpg.ms == 0 and timerpg.s == 0 and timerpg.m == 0):
			if state != DEATH || state != VICTORY:
				state = DEATH

	if get_tree().current_scene.name != "menu":
		if transition_shit.modulate.a > 0 and state != VICTORY:
			transition_shit.modulate.a -= (0.05*delta)*60
		if countdown > 0:
			countdown-=(1*delta)*60
			can_act = false
		#change the sprite to the GO sprite bitch

		if countdown <= 60:
			readygo.texture = goTex
		if countdown <= 0:
			countdown = 0
			if readygo.visible == true:
				can_act = true
				readygo.scale.x += (0.05*delta)*60
				readygo.scale.y += (0.05*delta)*60
				readygo.modulate.a -= (0.05*delta)*60
				if readygo.modulate.a <= 0:
					readygo.visible = false 
					transition_shit.modulate.a = 0


	#TextBox Interactions
	if Textbox.vis == false and sign_timer != 0:
		sign_timer-=(1*delta)*60
	sprite_direction(delta)
	combo_break_tolerance-=1

	if combo_break_tolerance <= 0:
		combo = 0
		combo_break_tolerance = 60
#
#	if combo >= 3:
#		$Camera2D/RichTextLabel.visible = true
#	else:
#		$Camera2D/RichTextLabel.visible = false
	$Camera2D/RichTextLabel.combo = combo
	###################################################### ##############################################
	#if get_node("../AudioStreamPlayer2/").actualbpm >= 200:
	#	AAAAAAAAA = get_node("../AudioStreamPlayer2/").Securezone(50.0,50.0) #Safezone
	#elif get_node("../AudioStreamPlayer2/").actualbpm >= 160 and get_node("../AudioStreamPlayer2/").actualbpm < 200:
	#	AAAAAAAAA = get_node("../AudioStreamPlayer2/").Securezone(40.0,50.0) #Safezone
	#else:

	AAAAAAAAA = get_node("../AudioStreamPlayer2/").Securezone(30.0,40.0,300,1.1) #Safezone
	####################################################################################################
	#Apply gravity
	if verticalMovement.y >= max_fallSpeed:
		$Line2D.visible = true
		verticalMovement.y = max_fallSpeed
	#gravity should NOT be applied during dash
	if has_dashed == false:
		verticalMovement.y += gravity
		verticalMovement = move_and_slide(verticalMovement, Vector2(0,-1))
	if is_on_floor():#Line2D is the trail effect when you dash or when you fall for too long
		if amIinTheFuckinAir == true:
			recordyposition = position.y
			$Line2D.visible = false
			amIinTheFuckinAir = false
			jump_number = 0
		antijumppress = false
	else:
		if amIinTheFuckinAir == false:
			amIinTheFuckinAir = true
			
	if amIinTheFuckinAir == true:
		play_idle_once = false
		if verticalMovement.y < 0:
			if can_act == true:
				$AnimationPlayer.play("Jump")
				$AnimationPlayer2.play("Jump")
				$AnimationPlayer3.play("Jump")
		elif verticalMovement.y > 0:
			if can_act == true:
				$AnimationPlayer.play("Fall")
				$AnimationPlayer2.play("Jump")
				$AnimationPlayer3.play("Fall")
	else:
		if state==MOVE:
			if can_act == true:
				animationPlayer.play("Walk")
				$AnimationPlayer2.play("Walk")
				$AnimationPlayer3.play("Walk")
		if state==IDLE:
				if play_idle_once == false and can_act == true:
					animationPlayer.play("Idle")
					$AnimationPlayer2.play("Idle")
					$AnimationPlayer3.play("Idle")
					play_idle_once = true
	#JUMPING
	if Input.is_action_just_pressed("jump") and can_act:
		if amIinTheFuckinAir == false and text_sign.visible == true and sign_timer == 0:
			can_act = false
			state = CONVERSATION
			$AnimationPlayer.play("Idle")
			$AnimationPlayer2.play("Idle")
			$AnimationPlayer3.play("Idle")
		else:
			if (AAAAAAAAA == false) and !has_dashed:
				verticalMovement.y = jump_speed
				state = TRIP
				combo_break_tolerance = 75
				soundplay(load("res://sound_effect stuff/Hit.wav"))#Lmao noob you didnt press the key to the beat get destroyed
			else:
				if get_tree().current_scene.name == "World2"||get_tree().current_scene.name == "World1-lvl2":
					if blueblock == 0:
						blueblock = 1
					else:
						blueblock = 0
	
				if jump_number == 0 and amIinTheFuckinAir == false:
					recordyposition = position.y
				if state != TRIP:
					rhythmind.play("beat")
				if !has_dashed:
					soundplay(load("res://sound_effect stuff/sfx_clap.wav"))
				combo_break_tolerance = 60
				combo +=1
				amIinTheFuckinAir = true
				jump_power = 0
				if antijumppress == false:
					antijumppress = true
				jump_number+=1
				if jump_number < 2:
					if !has_dashed:
						soundplay(load("res://sound_effect stuff/sfx_jump.wav"))
	if Input.is_action_pressed("jump") and antijumppress == true and can_act:
		if jump_power < 10 and jump_number < 2:
			jump_power+=1
			verticalMovement.y = jump_speed
	if Input.is_action_just_released("jump") and verticalMovement.y < 0 and can_act:
		jump_power = 21
		verticalMovement.y = -12.5

	#DASH
	if Input.is_action_just_pressed("dash") and (has_dashed == false) and can_act:
		if amIinTheFuckinAir == false and text_sign.visible == true:
			can_act = false
			state = CONVERSATION
			$AnimationPlayer.play("Idle")
			$AnimationPlayer2.play("Idle")
			$AnimationPlayer3.play("Idle")
		else:
			if (AAAAAAAAA == false):
				verticalMovement.y = -250
				state = TRIP
				combo_break_tolerance = 75
				soundplay(load("res://sound_effect stuff/Hit.wav"))#Lmao noob you didnt press the key to the beat get destroyed
			else:
				if get_tree().current_scene.name == "World2"||get_tree().current_scene.name == "World1-lvl2":
					if blueblock == 0:
						blueblock = 1
					else:
						blueblock = 0
				if state != TRIP:
					rhythmind.play("beat")
				
				soundplay(load("res://sound_effect stuff/sfx_clap.wav"))
				combo +=1
				combo_break_tolerance = 60
				$Line2D.visible = true
				$Line2D.remove_point(0)
				#Oh yea you gotta have different sprites for the dash afterimage effect,
				#why? because i suck at code n couldn't figure out how to flip particles
				#lmfao just add the variables for your character below
				#example:
				#var coolcharacterdashleft = preload("res://sprites/custom sprites/spr_custom_dash_left")
				var frogdashleft = preload("res://sprites/Characters/Frog/spr_frog_dash_leftt.png")
				var frogdashright = preload("res://sprites/Characters/Frog/spr_frog_dash_right.png")
				
				var dashleft = preload("res://sprites/Characters/Karu/spr_karu_dash.png")
				var dashright = preload("res://sprites/Characters/Karu/spr_karu_dash_right.png")
				
				var lizdashleft = preload("res://sprites/Characters/liz/spr_liz_dash_left.png")
				var lizdashright = preload("res://sprites/Characters/liz/spr_liz_dash_right.png")
				#I forgot to change this to a switch / match and i refuse to do so now
				if character_number == 1:
					if facing_front == 1:
						$Particles2D.texture = dashright
					else:
						$Particles2D.texture = dashleft
				elif character_number == 3:
					if facing_front == 1:
						$Particles2D.texture = frogdashright
					else:
						$Particles2D.texture = frogdashleft
				elif character_number == 2:
					if facing_front == 1:
						$Particles2D.texture = lizdashright
					else:
						$Particles2D.texture = lizdashleft
				$Particles2D.emitting=true
				state = DASH
				has_dashed = true
				soundplay(load("res://sound_effect stuff/sfx_dash.wav"))
	#SPAWNPOINT BULLSHIT
	if startingposx == null and startingposy == null:
		startingposx = position.x
		startingposy = position.y
	#STATES
	match state:
		IDLE:
			idle_state(delta)
		MOVE:
			move_state(delta)
		DASH:
			dash_state(delta)
		TRIP:
			trip_state(delta)
		DEATH:
			death_state(delta)
		VICTORY:
			victory_state(delta)
		CONVERSATION: 
			conversation_state(delta)
	if Input.is_action_just_pressed("restart"): #BORRA ESTA MADRE CUANDO LO COMPILES AAAAA
		#No quiero - SleP16
		get_tree().reload_current_scene() 
#TEXT OR CONVERSATIONS
func conversation_state(_delta):
	if sign_timer == 0:
		Textbox.vis = true
		inst_sign.active = true
		sign_timer = 60
	
	can_act = false
	movement.x = 0
	verticalMovement.y = 0
	if sign_timer > 0 and Textbox.vis == false:
		state = IDLE
		can_act = true
#MOVEMENT 
func im_speed(_delta):
	if can_act == true:
		if hsp < max_speed:
			hsp+=friccion
		elif hsp >= max_speed:
			hsp = max_speed 
		movement.x = hsp*facing_front
	
#BRUH WHY AIN'T YOU MOVIN'
func idle_state(_delta):
	if is_on_floor():
		jump_number = 0
	if Input.is_action_pressed('ui_right') or Input.is_action_pressed('ui_left'):
		state = MOVE
	if hsp != 0:
		hsp = lerp(hsp,0,decel)
	movement.x = hsp*facing_front
	movement = move_and_slide(movement)

#WHICH DIRECTION THE FOOKIN PLAYER IS LOOKIN' AT
func sprite_direction(_delta):
	if can_act == true:
		if facing_front == 1:
			$Sprite.set_flip_h( false )
			$FrogSprite.set_flip_h( false )
			$Liz.set_flip_h( false )
		else:
			$Sprite.set_flip_h( true )
			$FrogSprite.set_flip_h( true )
			$Liz.set_flip_h( true )
			
#PRESSING KEYS AND STUFF
func move_state(delta):
	if is_on_floor():
		jump_number = 0
	if Input.is_action_pressed("ui_right"):
		facing_front = 1
		im_speed(delta)
		movement = move_and_slide(movement, Vector2(1,0))
	elif Input.is_action_pressed("ui_left"):
		facing_front = -1
		im_speed(delta)
		movement = move_and_slide(movement, Vector2(-1,0))
	else:
		if is_on_floor():
			animationPlayer.play("Idle")
			$AnimationPlayer2.play("Idle")
			$AnimationPlayer3.play("Idle")
		state = IDLE

#ded
func death_state(_delta):
	can_act = false
	gravity = 0
	movement.x = 0
	verticalMovement.y = 0
	death_timer+=(1*deltadeath)*60
	if death_timer > 0:
		if dedDone == false:
			$Particles2D.emitting=false
			dedDone = true
			soundplay(load("res://sound_effect stuff/explode (1).wav"))
			$AnimationPlayer.play("death")
			$FrogSprite.visible = false
			$Liz.visible = false
	if death_timer >= 120:
		dedDone = false
		time = 0
		can_act = true
		has_dashed = false
		verticalMovement.y = 0
		movement.x = 0
		hsp = 0
		vsp = 0
		play_idle_once = false
		if character_number == 3:
			$FrogSprite.visible = true
		if character_number == 2:
			$Liz.visible = true
		$AnimationPlayer.play("respawn")
		$AnimationPlayer2.play("Fall")
		$AnimationPlayer3.play("Fall")

		state = MOVE
		death_timer = 0
		dash_timer = 0
		reset_gravity()
		position.x = startingposx
		position.y = startingposy
		if get_tree().current_scene.name == "World3":
			if timerpg.s == 0:
				get_tree().reload_current_scene() 
		
#Do i need to explain this one
func dash_state(delta):
	gravity = 0
	verticalMovement.y = -25
	animationPlayer.play("Dash")
	$AnimationPlayer2.play("Dash")
	$AnimationPlayer3.play("Dash")
	movement.x = 320*facing_front
	movement = move_and_slide(movement,Vector2(facing_front,0))
	dash_timer+=(1*delta)*60
	if dash_timer >= 13:
		dash_timer = 0
		reset_gravity()
		state=IDLE
		has_dashed = false
		$Line2D.visible = false
		$Line2D.remove_point(0)

#victory royale
func victory_state(delta):
	can_act = false
	hsp = 0
	vsp = 0
	movement.x = 0
	verticalMovement.y = 0
	gravity = 0
	finish_timer+=(1*delta)*60
	if finish_timer >=120:
		transition_shit.modulate.a+=(0.05*delta)*60
		if transition_shit.modulate.a >= 1:
			if get_tree().current_scene.name == "tutoiral" || get_tree().current_scene.name == "World3":
				get_tree().change_scene("res://Scenes/mainmenu.tscn")
			if get_tree().current_scene.name == "World":
				get_tree().change_scene("res://Scenes/World_1/World1-lvl2.tscn") 
			if get_tree().current_scene.name == "World1-lvl2":
				get_tree().change_scene("res://Scenes/World_2/World2.tscn") 
			if get_tree().current_scene.name == "World2":
				get_tree().change_scene("res://Scenes/World_3_REAL/World3.tscn")

	
	animationPlayer.play("Victory")
	$AnimationPlayer2.play("Victory")
	$AnimationPlayer3.play("Victory")

#whoops
func trip_state(delta):
	can_act = false
	time = time + delta
	animationPlayer.play("Trip")
	$AnimationPlayer2.play("Trip")
	$AnimationPlayer3.play("Trip")
	if is_on_floor():
		hsp = 0
		movement.y = 0
		movement.x = 0
		animationPlayer.play("Grounded")
		$AnimationPlayer2.play("Grounded")
		$AnimationPlayer3.play("Grounded")
		seconds = seconds + delta
		if seconds>0.2 and seconds < 0.4:
			animationPlayer.play("Wakeup")
			$AnimationPlayer2.play("Grounded")
			$AnimationPlayer3.play("Wakeup")
		elif seconds >= 0.4:
			time = 0
			hsp = 0
			movement.y = 0
			movement.x = 0
			can_act = true
			seconds = 0
			animationPlayer.play("Idle")
			$AnimationPlayer2.play("Idle")
			$AnimationPlayer3.play("Idle")
			state=IDLE
			reset_gravity()
	else:
		if time > 0.2:
			movement.x = lerp(movement.x,0,0.1)
			movement = move_and_slide(movement, Vector2(1*facing_front,0))
		else:
			if facing_front < 0:
				movement.x = -137
				movement = move_and_slide(movement, Vector2(-1,0))
			else:
				movement.x = 115
				movement = move_and_slide(movement, Vector2(1,0))

func reset_gravity():
	if character_number == 1:
		gravity = 18
	elif character_number == 2 || character_number == 3:
		gravity = 13
	else:
		gravity = 20

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		state = DEATH

func _on_finish_line_body_entered(body):
	if body.get_name() == "Player":
			if state !=VICTORY:
				hsp = 0
				vsp = 0
				movement.x = 0
				verticalMovement.y = 0
				soundplay(load("res://sound_effect stuff/positive.wav"))
				state=VICTORY
#JSON stuff
func save_data(save_path : String, dataCh) -> void:
	var data_string = JSON.print(dataCh)
	var file = File.new()
	var json_error = validate_json(data_string)
	if json_error:
		print_debug("JSON IS NOT VALID FOR: " + data_string)
		print_debug("error: " + json_error)
		return
	file.open(save_path, file.WRITE)
	file.store_string(data_string)
	file.close()


func load_save(save_path : String):
	var file : File = File.new()
	if not file.file_exists(save_path):
		print_debug('file [%s] does not exist; creating' % save_path)
		save_data(save_path, {})
	file.open(save_path, file.READ)
	var json : String = file.get_as_text()
	var dataCh = parse_json(json)
	file.close()

	return data

#sound effects handler
func soundplay(_sound):
	var select_sound = AudioStreamPlayer.new()
	self.add_child(select_sound)
	select_sound.stream = _sound
	if play_sfx == true:
		select_sound.play()
	if play_sfx == false and (select_sound.stream == load("res://sound_effect stuff/explode (1).wav")
		||select_sound.stream == load("res://sound_effect stuff/positive.wav")
		||select_sound.stream == load("res://sound_effect stuff/checkpoint.wav")
		||select_sound.stream == load("res://sound_effect stuff/sfx_teleport.wav")
		||select_sound.stream == load("res://sound_effect stuff/sfx_clock_collect.wav")):
		select_sound.play()
	select_sound.volume_db = -3
	if get_tree().current_scene.name == "menu":
		select_sound.volume_db = -180
	yield (select_sound, "finished")
	select_sound.queue_free()
	#print("Done")

func _on_Spikesss_body_entered(body):
	if body.get_name() == "Player":
		state = DEATH

func _on_Checkpoint_body_entered(_body):
	if emit_checkpoint_particles == false:
		checkpoint_particles.emitting = true
		emit_checkpoint_particles = true
		soundplay(load("res://sound_effect stuff/checkpoint.wav"))
		
	startingposx = actualcheckpoint.position.x
	startingposy = actualcheckpoint.position.y+52
	checkpoint.frame = 1
	
func load_game():
	var file = File.new()

	file.open(path, file.READ)
	
	var text = file.get_as_text()
	
	data = parse_json(text)
	
	file.close()

func _on_Spikesss18_body_entered(body):
	if body.get_name() == "Player":
		state = DEATH

func text_box():
	if text_sign.visible == true:
		inst_sign.active = true

func _on_Sign_body_exited(body):
	if body.get_name() == "Player":
		inst_sign.show_text = 0
		print(inst_sign.show_text)
		text_sign.visible = false


func _on_Sign_body_entered(body):
	if body.get_name() == "Player":
		text_sign.visible = true


func _on_Sign2_body_entered(body):
	if body.get_name() == "Player":
		text_sign.visible = true
		inst_sign.show_text = 1
		print(inst_sign.show_text)


func _on_RedPortal_body_entered(body: Node) -> void:
	position.x = portalBlue.position.x
	position.y = portalBlue.position.y
	verticalMovement.y = 0
	vsp = 0
	soundplay(load("res://sound_effect stuff/sfx_teleport.wav"))


func _on_Clock_body_entered(body: Node) -> void:
	if body.get_name() == 'Player':
			timerpg.s+=5
			soundplay(load("res://sound_effect stuff/sfx_clock_collect.wav"))

