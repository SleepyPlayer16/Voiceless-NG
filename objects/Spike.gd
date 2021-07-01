extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().current_scene.name == "World":
		$Sprite.frame = 0

	elif get_tree().current_scene.name == "World2":
		$Sprite.frame = 1

	elif get_tree().current_scene.name == "World3":
		$Sprite.frame = 2

	elif get_tree().current_scene.name == "tutoiral":
		$Sprite.frame = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):	
	


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	$CollisionShape2D.disabled = true
	$Sprite.visible = false

func _on_VisibilityNotifier2D_viewport_entered(_viewport):
	$CollisionShape2D.disabled = false
	$Sprite.visible = true

