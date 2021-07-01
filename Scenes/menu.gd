extends Node2D

var path = "user://data.json"
onready var audio = get_node("../AudioStreamPlayer2")
var default_data = {
	"user_data" : {
		"offset" : 0.000,
		"volume" : 0,
		"sfx_active" : true,
		"vol_sprite_frame" : 0,
		"control_mode" : 0,
		"liz_unlocked" : false,
		"selected_character" : 1
	}
}

var data = { }

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	save_game()

func load_game():
	var file = File.new()
	

	file.open(path, file.READ)
		
	var text = file.get_as_text()
	
	data = parse_json(text)

	if !file.file_exists(path):
		reset_data()
		return	

	file.close()
		
func save_game():
	var file
	
	file = File.new()
	
	file.open(path, File.WRITE)
	
	file.store_line(to_json(data))
	
	file.close()
	
func reset_data():
	data = default_data.duplicate(true)
