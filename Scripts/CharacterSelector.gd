extends Node2D

var chosen_character = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_just_pressed("ui_left") or  Input.is_action_just_pressed("ui_right"):
		if chosen_character == 0:
			chosen_character = 1
		else:
			chosen_character = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
