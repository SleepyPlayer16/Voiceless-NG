extends KinematicBody2D

var char_karu = {
	max_speed = 150,
	max_fallSpeed = 350,
	gravity = 18,
	friccion = 15,
	decel = 0.3
}

var char_frog = {
	max_speed = 110,
	max_fallSpeed = 350,
	gravity = 13,
	friccion = 10,
	decel = 0.1
}

var character_data = {
	char_karu = char_karu,
	char_frog = char_frog
}

# Called when the node enters the scene tree for the first time.
func _ready():
	save_data("user://characters.dat", character_data)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func save_data(save_path : String, data) -> void:
	var data_string = JSON.print(data)
	var file = File.new()
	var json_error = validate_json(data_string)
	if json_error:
		print_debug("JSON IS NOT VALID FOR: " + data_string)
		print_debug("error: " + json_error)
		return
	file.open(save_path, file.WRITE)
	file.store_string(data_string)
	file.close()


func load_data(save_path : String):
	var file : File = File.new()
	if not file.file_exists(save_path):
		print_debug('file [%s] does not exist; creating' % save_path)
		save_data(save_path, {})
	file.open(save_path, file.READ)
	var json : String = file.get_as_text()
	var data = parse_json(json)
	file.close()

	return data
