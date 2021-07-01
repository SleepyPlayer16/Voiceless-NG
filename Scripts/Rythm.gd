extends CanvasLayer

var scene = preload("res://Scenes/FUCKINGnote.tscn")
var id
onready var conductor = get_node("../AudioStreamPlayer2")
var bps

func _ready():
	bps = conductor.bps

func spawn_note():
	id = scene.instance().duplicate()
	add_child(id)
