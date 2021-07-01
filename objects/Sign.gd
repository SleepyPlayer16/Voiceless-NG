extends Area2D


var active = false
onready var player = get_node("../Player")
var jumpaction
var dashaction
var show_text = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(_delta):
	if active == true:
		active = false
		for action in InputMap.get_action_list("jump"):
			if action is InputEventKey:
				jumpaction = (OS.get_scancode_string(action.scancode))
		for action in InputMap.get_action_list("dash"):
			if action is InputEventKey:
				dashaction = (OS.get_scancode_string(action.scancode))
		if show_text == 0:
			Textbox.queue_text("Try jumping with "+str(jumpaction)+".")
			Textbox.queue_text("You can hold the button to jump longer.")
			Textbox.queue_text("You also need to time your jump to the beat!")
			Textbox.queue_text("The notes below will help you figure out the rhythm.")
		elif show_text == 1:
			Textbox.queue_text("Try dashing with "+str(dashaction)+".")
			Textbox.queue_text("You also have to dash to the beat!")
			Textbox.queue_text("There will be sections where jumping is useless.")
			Textbox.queue_text("So remember to dash instead.")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
