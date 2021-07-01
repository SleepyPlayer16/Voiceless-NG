extends CollisionShape2D

onready var sprite = get_node("../spr_jumpblockBlue")
onready var spritered = get_node("../spr_jumpblockRed")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if sprite.frame == 0:
		if disabled == true:
			print("collision enabled")
			disabled = false
	else:
		if disabled == false:
			print("collision disabled")
			disabled = true
