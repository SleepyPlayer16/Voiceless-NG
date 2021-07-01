extends CanvasLayer

var char_read_rate = 0.095

onready var textbox_container = $Textboxcontainer
onready var start_symbol = $Textboxcontainer/MarginContainer/HBoxContainer/StarSymbol
onready var end_symbol = $Textboxcontainer/MarginContainer/HBoxContainer/End
onready var label = $Textboxcontainer/MarginContainer/HBoxContainer/Label2

var vis = false

enum state{
	READY,
	READING,
	FINISHED
}

var current_state = state.READY
var text_queue = []
# Called when the node enters the scene tree for the first time.
func _ready():
	hide_textbox()
	
func _process(_delta):
	if get_tree().current_scene.name == "menu":
		if Input.is_action_just_pressed("Fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen
	match current_state:
		state.READY:
			if !text_queue.empty():
				end_symbol.text =""
				add_text()
		state.READING:
			if Input.is_action_just_pressed("dash") || Input.is_action_just_pressed("jump"):
				label.percent_visible = 1.0
				$Tween.stop_all()
				end_symbol.text ="v"
				change_state(state.FINISHED)
		state.FINISHED:
			if Input.is_action_just_pressed("dash") || Input.is_action_just_pressed("jump"):
				change_state(state.READY)
				if text_queue.empty():
					hide_textbox()
	
func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()
	vis = false

func start_text():
	start_symbol.text = ">"
	textbox_container.show()
	vis = true
	
func add_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.percent_visible = 0.0
	change_state(state.READING)
	start_text()
	$Tween.interpolate_property(label,"percent_visible", 0.0, 1.0, len(next_text) * char_read_rate, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(_object,_key):
	end_symbol.text ="v"
	change_state(state.FINISHED)

func change_state(next_state):
	current_state = next_state
	match current_state:
		state.READY:
			pass
		state.READING:
			pass
		state.FINISHED:
			pass
			
func appear():
	var select_sound = AudioStreamPlayer.new()
	self.add_child(select_sound)
	select_sound.stream = load("res://sound_effect stuff/block_appear.wav")
	select_sound.play()
