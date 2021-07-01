extends StaticBody2D

onready var rhythm = get_node("../../AudioStreamPlayer2")
var beat = 1
var actualbeat = 1
var event = 1
var timer = 60
var process_code = true
# Called when the node enters the scene tree for the first time.
func _ready():
	beat = rhythm.beat_num
	
func _process(_delta):
	
	if beat != rhythm.beat_num:
		beat = rhythm.beat_num
		
	if beat == 1 and $Sprite.frame == 0 and event == 1:
		$CollisionShape2D.disabled = true
		$Sprite.frame = 1
		appear()
		event = 0
	if beat == 2:
		event = 1
	if beat == 1 and $Sprite.frame == 1 and event == 1:
		$CollisionShape2D.disabled = false
		$Particles2D.emitting = true
		$Sprite.frame = 0
		appear()
		event = 0

func appear():
	var select_sound = AudioStreamPlayer2D.new()
	self.add_child(select_sound)
	select_sound.stream = load("res://sound_effect stuff/block_appear.wav")
	select_sound.max_distance =  500
	select_sound.volume_db = 3
	select_sound.play()

func _on_VisibilityNotifier2D_viewport_entered(_viewport):
	if beat == 1 and $Sprite.frame == 1 and event == 1:
		$CollisionShape2D.disabled = false
	$Sprite.visible = true 


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
