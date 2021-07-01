extends CanvasLayer

func _ready():
	transition()
	
func transition():
	$AnimationPlayer.play("fade")
func transition2():
	$AnimationPlayer.play("fade2")
func transition3():
	$AnimationPlayer.play("scene2")
func transition4():
	$AnimationPlayer.play("fad3")
func fuckingexit():
	queue_free()
