extends Camera2D

onready var rhyth = get_node("../../AudioStreamPlayer2")
var zoom_active = false
var timer = 0
func _ready():
	if get_tree().current_scene.name != "menu":
		zoom.x = 0.25
		zoom.y = 0.25


func _process(delta):
	if get_tree().current_scene.name != "menu":
		zoom.x = lerp(zoom.x,0.5,(0.05*delta)*60)
		zoom.y = lerp(zoom.y,0.5,(0.05*delta)*60)
#	if rhyth.songPosInBeats%4 == 0 and zoom_active == false:
#		zoom_active = true
#		zoom.x=0.49
#		zoom.y=0.49
#	if !(zoom.x==0.5 and zoom.y==0.5):
#		zoom.x=lerp(zoom.x,0.5,0.05)
#		zoom.y=lerp(zoom.y,0.5,0.05)
#		timer+=1
#	if timer >= 60:
#		zoom.x=0.5
#		zoom.y=0.5
#		zoom_active = false
#		timer = 0
