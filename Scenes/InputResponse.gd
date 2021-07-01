extends VBoxContainer

func _ready() -> void:
	pass # Replace with function body.

func set_text(input: String, response: String):
	$InputHistory.text = " > " + input
	$Response.text = response