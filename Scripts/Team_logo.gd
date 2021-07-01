extends Sprite
var alpha=-100
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a=0
	pass
	
func _process(delta):
	alpha+=(1*delta)*60
	if alpha < 100 && alpha > 0:
		set_modulate(lerp(get_modulate(), Color(1,1,1,1), (0.05*delta)*60))
	else:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), (0.05*delta)*60))
	if alpha > 220:
		_add_a_scene_manually()
	if Input.is_action_just_pressed("ui_accept"):
		alpha = 180
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), 1))


func _add_a_scene_manually():
		queue_free()
		get_node("../Sprite").fuckingrip()
		get_tree().change_scene("res://Scenes/mainmenu.tscn")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
