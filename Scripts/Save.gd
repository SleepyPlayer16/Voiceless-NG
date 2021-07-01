extends Node

var path = "user://data.json"
onready var audio = get_node("../AudioStreamPlayer2")
var liz_text = preload("res://sprites/menu/spr_menu_liz.png")
var karu_text = preload("res://sprites/menu/spr_menu_karu.png")
var froo_text = preload("res://sprites/menu/spr_menu_Froo.png")
onready var spr = $spr_character
var timer = 0
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
	print(data)
	audio.offset = data.user_data["offset"]

#	if "offset" in data.user_data:
#		print("")
#	data.user_data["offset"] = 0.003
#	print(data)
func _process(_delta):

	if (data.user_data["selected_character"])==1:
		spr.texture = karu_text
		spr.position.y = 64

	elif (data.user_data["selected_character"])==2:
		spr.texture = liz_text
		spr.position.y = 94
	else:
		spr.texture = froo_text
		spr.position.y = 64	
						
func load_game():
	var file = File.new()
	
	if not file.file_exists(path):
		reset_data()
		return
	file.open(path, file.READ)
	
	var text = file.get_as_text()
	
	data = parse_json(text)
	
	file.close()
	
func save_game():
	var file
	
	file = File.new()
	
	file.open(path, File.WRITE)
	
	file.store_line(to_json(data))
	
	file.close()
	
func reset_data():
	data = default_data.duplicate(true)

