extends MarginContainer


onready var number_label = $Bars/LifeBar/Count/Background/Number
onready var bar = $Bars/LifeBar/TextureProgress
onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	var player_max_health = $"../World/Player".max_health
	bar.max_value = player_max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
