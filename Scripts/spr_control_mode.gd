extends Sprite

onready var controller = get_node("../../controls/Control")


# Called when the node enters the scene tree for the first time.
func _ready():
	type()

func _process(_delta):
	type()

func type():
	if controller.control_mode == 0:
		frame = 0
	else:
		frame = 1

