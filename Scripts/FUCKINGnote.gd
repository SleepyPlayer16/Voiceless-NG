extends Node2D

onready var rhythm = get_node("../../AudioStreamPlayer2")
onready var rythm = get_node("../../Rythm/rhythm_container")
onready var controller = get_node("Control")
var AAAAAAAAA = null
var bps = 1
var length 
var bpm = 1
var speed
var should_move = true
var disappear
var note_instance = null
var songlen=0.0
var songpos=0.0
var safezone = null
var movement = 0.0
var lasthalfbeat = 0
var scrollspeed = 1.0
var confirm_press = false
var msafe
var hold_note = false
var spawntimer = 10
#WARNING, note movement code is shitty as FUCK i apologize in advance for this mess lmfoa
#XDD este we ta todo pendejo pa programar
#q dijistes ijo de re1000
func _ready():
	#songlen = rhythm.songLength
	$Control/HBoxContainer/AnimatedSprite.play("Default",false)
	$Control/HBoxContainer/AnimatedSprite.modulate.a = 0
	$Control/HBoxContainer/AnimatedSprite.scale.x = 2
	$Control/HBoxContainer/AnimatedSprite.scale.y = 2
	bps = rhythm.bps
	bpm = rhythm.actualbpm

	#Changes the scrollspeed depending on the bpm bc i suck at coding
	if bpm >= 96 and bpm <= 150:
		scrollspeed = 1.0
	elif bpm >= 151 and bpm  <= 200 :
		scrollspeed = 1.0
	elif bpm > 200:
		scrollspeed = 1.0
	else:
		scrollspeed = 1.0
	#Spawn position
	position.x = (480+(128*scrollspeed))
	length = rhythm.songLength

	if get_tree().current_scene.name == "menu":
		if rythm.visible == false:
			visible = false
		else:
			visible = true
		position.y = 233
	else:
		position.y = 498
	#Calculates speed with song data n' scroll speed
	speed = (128/bps)/60*scrollspeed
	spawntimer*=scrollspeed
	if speed < 0:
		speed*=-1
	movement = Vector2(speed,0)

func _process(delta):
	if $Control/HBoxContainer/AnimatedSprite.modulate.a != 1:
		$Control/HBoxContainer/AnimatedSprite.modulate.a += (((0.15*delta)*scrollspeed)*60)
	if $Control/HBoxContainer/AnimatedSprite.modulate.a > 1:
		$Control/HBoxContainer/AnimatedSprite.modulate.a = 1
	
	if position.x <= 480-(64*scrollspeed):
		$Control/HBoxContainer/AnimatedSprite.modulate.a -= (((0.3*delta)*scrollspeed)*60)
	#makes sure the FUCKINGG notes gets deleted
	if position.x <= 480-(128*scrollspeed):
		#print("AAAAAAAAAAAAAAAAAAAAAAAAA")
		queue_free()

	if position.x <= 480-(64*scrollspeed):
		if hold_note == true:
			hold_note = false

	if rythm.visible == false:
		visible = false
	else:
		visible = true

	var safe

	safe = get_node("../../AudioStreamPlayer2/").Securezone(30.0,40.0,300,1.1) 

	spawntimer-=((1*delta)*60)*scrollspeed#Prevents notes from getting deleted by other notes
	
	if should_move == true:
		if hold_note == false:
			#Note movement
			position-=(movement*delta)*60


	msafe = get_node("../../AudioStreamPlayer2/").safedata

	inputget(safe)
	safezone = safe
	if should_move == false:
		reposition()

func inputget(sf):
	if Input.is_action_just_pressed("dash") || Input.is_action_just_pressed("jump") || Input.is_action_just_pressed("menujump") || Input.is_action_just_pressed("menudash"):	
		if (sf == true and (position.x <= 480+(128*stepify(msafe,0.01))*scrollspeed)) and spawntimer <= 0:
			reposition()

func reposition():
	if hold_note == false:
		hold_note = true
		if position.x >= 480-(64*scrollspeed):
			position.x = 480
			$Control/HBoxContainer/AnimatedSprite.play("Hit",false)


func _on_AnimatedSprite_animation_finished():
	if hold_note == true:
		queue_free()
