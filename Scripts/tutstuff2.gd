extends Sprite


onready var player = get_node("../Player")
var jumpaction
var dashaction

# Called when the node enters the scene tree for the first time.
func _ready():
	for action in InputMap.get_action_list("jump"):
		if action is InputEventKey:
			jumpaction = (OS.get_scancode_string(action.scancode))
	for action in InputMap.get_action_list("dash"):
		if action is InputEventKey:
			dashaction = (OS.get_scancode_string(action.scancode))
	if dashaction == "Z":
		frame = 0
	else:
		frame = 1
