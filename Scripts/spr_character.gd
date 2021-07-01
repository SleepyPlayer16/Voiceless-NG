extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	position.x = lerp(position.x,-264,(0.04*delta)*60)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
