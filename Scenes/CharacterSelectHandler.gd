extends Node2D

onready var savedata = get_node("../MainMenuScreen")
onready var transition_rect = $ColorRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(_delta):
	if savedata.data.user_data["liz_unlocked"] == true:
		$spr_characterSelect.frame = 1
	else:
		$spr_characterSelect.frame = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
