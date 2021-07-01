extends Area2D


onready var player = get_node("../Player")

func _on_Clock_body_entered(body: Node) -> void:
	queue_free()
