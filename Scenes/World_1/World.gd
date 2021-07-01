extends Node2D


var bpm = 135.0
var friccion = 1000
var Beat_tmr
var starting
var securezone = true
var world_num = 1
var song = preload("res://Music/mus_world1.ogg")

func ready():
	
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
