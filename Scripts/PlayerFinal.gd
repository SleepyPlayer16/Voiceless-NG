#extends KinematicBody2D
#
#var GRAVITY = 22 #Atraccion hacia abajo default =27
#var FRICTION #cuando se esta en idle se multiplica por delta para frenar default=1000#var ACCELERATION= 1000 #Se multiplica por delta cuando se empieza a caminar default =1000
#const MAX_SPEED = 200 #Se multiplica por el vector para limitar la velocidad default = 200
#const MAXJUMPS = 1 #Numero maximo de saltos
#const MAXDASH = 1 #Dash maximo
#
##Declaracion de las posibles acciones en una lista enum
#enum{
#	MOVE,
#	DASH,
#	DASHLOAD,
#	TRIP,
#	DEATH,
#	VICTORY
#}
#
##Variables varias
#var state = MOVE
#var velocidad = Vector2.ZERO
#var facing_front = true
#var jumps = 0
#var hsp = 0
#var movimiento = 0
#var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#var seconds = 0 #Variable para almacenar tiempo en unas funciones
#var time = 0 #Variable para almacenar tiempo pero mas chilo
#var dashes = 0
#var beat = 0
#var bpm = 0 #160 165 Cambiar este bmp para otros mundos
#var timeforpos 
#var timeforneg
#var securezone = true #Si es true es seguro realizar una accion
#var playsong = false
#var startingposx = null
#var startingposy = null
#var death_timer = 0
#var font
#var crono = 30
#var is_moving = false
#var health = 100
#var has_finished_level = false
#var finish_timer = 0
#var num = 0
#onready var animationPlayer = $AnimationPlayer #Las animaciones se cargan
#onready var animationTree = $AnimationTree #Se carga el arbol de animaciones
#onready var animationState = animationTree.get("parameters/playback")
#
##funcion para cargar las animaciones
#func _ready():
#	animationTree.active = true
#
#func setup(World):
#	FRICTION = World.friccion
#
##Funcion para las posibles acciones
#func _physics_process(delta):
#
#	if startingposx == null and startingposy == null:
#		startingposx = position.x
#		startingposy = position.y
#	match state:
#		MOVE:
#			move_state(delta)
#		DASH:
#			dash_state(delta)
#		DASHLOAD:
#			dashload(delta)
#		TRIP:
#			trip_state(delta)
#		DEATH:
#			death_state(delta)
#		VICTORY:
#			victory_state(delta)
#	if Input.is_action_just_pressed("restart"): #BORRA ESTA MADRE CUANDO LO COMPILES AAAAA
#		get_tree().reload_current_scene() 
#
#func move_state(delta):
#	input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	if input_x > 0:
#		input_x = 1
#	if input_x < 0:
#		input_x = -1
#
#	if(Input.is_action_just_pressed("ui_right") and input_x == 1): 
#		facing_front = true
#	elif(Input.is_action_just_pressed("ui_left") and input_x == -1):
#		facing_front = false
#	elif(Input.is_action_just_pressed("ui_left")) and (Input.is_action_just_pressed("ui_right")):
#		facing_front = true
#
#
#	#Resetear valores
#	if is_on_floor():
#		jumps = 0
#		dashes = 0
#		time = 0
#		seconds = 0
#
#	if input_x !=0:
#		animationTree.set("parameters/Idle/blend_position", input_x)
#		animationTree.set("parameters/Walk/blend_position", input_x)
#		animationTree.set("parameters/Jump/blend_position", input_x)
#		animationTree.set("parameters/Fall/blend_position", input_x)
#		animationTree.set("parameters/Dash/blend_position", input_x)
#		animationTree.set("parameters/Trip/blend_position", input_x)
#		animationTree.set("parameters/Grounded/blend_position", input_x)
#		animationTree.set("parameters/Wakeup/blend_position", input_x)
#		animationTree.set("parameters/Victory/blend_position", input_x)
#
#		if is_on_floor():
#			animationState.travel("Walk")
#
#		velocidad.x+=hsp
#
#	else:
#		if is_on_floor():
#			animationState.travel("Idle")
#		velocidad = velocidad.move_toward(Vector2.ZERO, FRICTION * delta)
#
#	if(Input.is_action_just_pressed("jump")) and securezone==false and jumps ==0:
#		state = TRIP
#		get_node("../EnergyBar/GUI/HBoxContainer/Gauge").value-=10
#		trip()
#
#	if(Input.is_action_just_pressed("jump") and jumps < MAXJUMPS):
#		jump()
#		jumps += 1
#		velocidad.y = -500
#	if(Input.is_action_pressed("jump") and is_on_floor() == false):
#		animationState.travel("Jump")
#
#	if(Input.is_action_just_pressed("dash") and dashes == 0):
#		if securezone == false:
#			trip()
#			state = TRIP
#			get_node("../EnergyBar/GUI/HBoxContainer/Gauge").value-=10
#		else:
#			state = DASH
#			dash()
#	if get_node("../EnergyBar/GUI/HBoxContainer/Gauge").value==0:
#		state=DEATH
#	if velocidad.y > 0:
#		animationState.travel("Fall")
#	velocidad.y += GRAVITY
#	velocidad = move_and_slide(velocidad, Vector2.UP)
#
#func dash_state(delta):
#	GRAVITY = 0
#	velocidad.y = -0.5
#	animationState.travel("Dash")
#	$AnimationPlayer.play("Effect")
#	time = time + delta
#	velocidad = move_and_slide(velocidad)
#	if input_x ==0:
#		if facing_front == true:
#			velocidad.x = 350
#		else:
#			velocidad.x = -350
#	else:
#		velocidad.x = input_x * 350
#	if time > 0.2:
#		GRAVITY = 22
#		state = MOVE
#		velocidad.x = input_x * 155
#	dashes = 1
#
#func dashload(delta):
#	GRAVITY = 0
#	animationState.travel("Dash")
#	velocidad = move_and_slide(velocidad/2)
#	if(Input.is_action_just_released("dash")):
#		dash()
#		state = DASH
#	seconds = seconds + delta
#	if seconds > 0.3:
#		dash()
#		state = DASH
#
#func trip_state(delta):
#	velocidad = move_and_slide(velocidad/1.2, Vector2.UP)
#	time = time + delta
#	if time < 0.1:
#		velocidad.y = -100
#		velocidad.x = input_x * 300
#	else:
#		velocidad.y += GRAVITY*3
#	animationState.travel("Trip")
#	if is_on_floor():
#		animationState.travel("Grounded")
#		seconds = seconds + delta
#		if seconds>0.2 and seconds < 0.4:
#			animationState.travel("Wakeup")
#		elif seconds >= 0.4:
#			state=MOVE
#
#func death_state(delta):
#	GRAVITY = 22
#	velocidad.x = 0
#	velocidad.y = 0
#	death_timer+=1
#	if death_timer == 1:
#		explosion()
#		$AnimationPlayer.play("death")
#	if death_timer >= 120:
#		$AnimationPlayer.play("respawn")
#		get_node("../EnergyBar/GUI/HBoxContainer/Gauge").value=100
#		state = MOVE
#		death_timer = 0
#		position.x = startingposx
#		position.y = startingposy
#
#func victory_state(delta):
#	finish_timer+=1
#	if finish_timer >=120:
#		if num == 0:
#			get_tree().change_scene("res://World/World_2/World.tscn")
#		if num == 1:
#			get_tree().change_scene("res://menu.tscn") 
#		if num == 2:
#			get_tree().change_scene("res://menu.tscn")
#
#	if has_finished_level == false:
#		has_finished_level = true
#		animationState.travel("Victory")
#		finish()
#
#func explosion():
#	var select_sound = AudioStreamPlayer.new()
#	self.add_child(select_sound)
#	select_sound.stream = load("res://sound_effect stuff/explode (1).wav")
#	select_sound.play()
#
#func jump():
#	var select_sound = AudioStreamPlayer.new()
#	self.add_child(select_sound)
#	select_sound.stream = load("res://sound_effect stuff/sfx_jump.wav")
#	select_sound.play()
#
#func dash():
#	var select_sound = AudioStreamPlayer.new()
#	self.add_child(select_sound)
#	select_sound.stream = load("res://sound_effect stuff/sfx_dash.wav")
#	select_sound.play()
#
#func trip():
#	var select_sound = AudioStreamPlayer.new()
#	self.add_child(select_sound)
#	select_sound.stream = load("res://sound_effect stuff/Hit.wav")
#	select_sound.play()
#
#func finish():
#	var select_sound = AudioStreamPlayer.new()
#	self.add_child(select_sound)
#	select_sound.stream = load("res://sound_effect stuff/positive.wav")
#	select_sound.play()
#
#
#func _on_Area2D_body_entered(body):
#	if body.get_name() == "Player":
#		state = DEATH
#
#func _on_finish_line_body_entered(body):
#	if body.get_name() == "Player":
#			state=VICTORY
#
#func test():
#	securezone=true
#	timeforneg = Timer.new()
#	add_child(timeforneg)
#	timeforneg.set_wait_time((60.0/bpm)/7) #Menor valor = mayor tolerancia
#	timeforneg.set_one_shot(true)
#	timeforneg.start()
#	timeforneg.connect("timeout",self,"negative")
#
#func negative():
#	securezone=false
#	timeforpos = Timer.new()
#	add_child(timeforpos)
#	timeforpos.set_wait_time((60.0/bpm)/3) #DEBE SER MAYOR AL DE ARRIBA. Mayor valor = mas tolerancia
#	timeforpos.set_one_shot(true)
#	timeforpos.start()
#	timeforpos.connect("timeout",self,"positive")
#
#func positive():
#	securezone=true
