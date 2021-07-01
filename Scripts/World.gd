extends Node2D

onready var player_node = $Player
var BPM = 165.0
var friccion = 1000
var Beat_tmr
var starting
var securezone = true
var world_num = 0
func _ready():
	player_node.setup(self)
	starting = Timer.new()
	add_child(starting)
	starting.set_wait_time(1)
	starting.set_one_shot(true)
	starting.start()
	starting.connect("timeout",self,"delay")
	
func metronome():
	var select_sound = AudioStreamPlayer.new()
	self.add_child(select_sound)
	select_sound.stream = load("res://sound_effect stuff/Metronome.wav")
	select_sound.play()
	select_sound.set_volume_db(-10)

func delay():
	Beat_tmr = Timer.new()
	add_child(Beat_tmr)
	Beat_tmr.set_wait_time(60.0/BPM)
	Beat_tmr.start()
	$AudioStreamPlayer.play()
	Beat_tmr.connect("timeout",self,"metronome")
	Beat_tmr.connect("timeout",player_node,"test")
