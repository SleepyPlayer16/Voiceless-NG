extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position.y = lerp(position.y,-176,(0.04*delta)*60)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
