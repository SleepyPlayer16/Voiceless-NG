extends StaticBody2D

onready var player = get_node("../Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if player.blueblock == 1:
		$spr_jumpblockRed.frame = 0
		$CollisionShape2D.disabled = false
	else:
		$spr_jumpblockRed.frame = 1
		$CollisionShape2D.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
