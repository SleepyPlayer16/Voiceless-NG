extends Control

const INPUT_ACTIONS = ["jump","dash"]
const CONFIG_FILE = "user://input.cfg"

var action # To register the action the UI is currently handling
var button # Button node corresponding to the above action
var control_mode = 1 #0 = A 1 = B
var should_save = false

func _ready():
	load_config()
	_changeInput()
func _process(_delta):
	if should_save:
		_changeInput()
		should_save = false

func _changeInput():

	if control_mode == 0:
		var dash = InputEventKey.new()
		var jump = InputEventKey.new()
		dash.scancode = KEY_Z
		jump.scancode = KEY_X

		InputMap.action_erase_event('dash',dash)
		InputMap.erase_action('dash')
		InputMap.add_action('dash')
		InputMap.action_add_event('dash', dash)

		InputMap.action_erase_event('jump',jump)
		InputMap.erase_action('jump')
		InputMap.add_action('jump')
		InputMap.action_add_event('jump', jump)
		if should_save:
			save_to_config("input", dash, dash.scancode)
			save_to_config("input", jump, jump.scancode)
	if control_mode == 1:
		var dash = InputEventKey.new()
		var jump = InputEventKey.new()
		dash.scancode = KEY_X
		jump.scancode = KEY_Z
		InputMap.action_erase_event('dash',dash)
		InputMap.erase_action('dash')
		InputMap.add_action('dash')
		InputMap.action_add_event('dash', dash)

		InputMap.action_erase_event('jump',jump)
		InputMap.erase_action('jump')
		InputMap.add_action('jump')
		InputMap.action_add_event('jump', jump)
		if should_save:
			save_to_config("input", dash, dash.scancode)
			save_to_config("input", jump, jump.scancode)
		
func save_to_config(_section, _key, _value):
	"""Helper function to redefine a parameter in the settings file"""
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err:
		print("Error code when loading config file: ", err)
	else:
		for action_name in INPUT_ACTIONS:
			var action_list = InputMap.get_action_list(action_name)
			# There could be multiple actions in the list, but we save the first one by default
			var scancode = OS.get_scancode_string(action_list[0].scancode)
			config.set_value("input", action_name, scancode)
		config.save(CONFIG_FILE)
		
func load_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err == OK: # Assuming that file is missing, generate default config
		for action_name in config.get_section_keys("input"):
			
			# Get the key scancode corresponding to the saved human-readable string
			var scancode = OS.find_scancode_from_string(config.get_value("input", action_name))
			# Create a new event object based on the saved scancode
			var event = InputEventKey.new()
			event.scancode = scancode
			# Replace old action (key) events by the new one
			for old_event in InputMap.get_action_list(action_name):
				if old_event is InputEventKey:
					InputMap.action_erase_event(action_name, old_event)
			InputMap.action_add_event(action_name, event)

	else: # ConfigFile was properly loaded, initialize InputMap
		for action_name in INPUT_ACTIONS:
			var action_list = InputMap.get_action_list(action_name)
			# There could be multiple actions in the list, but we save the first one by default
			var scancode = OS.get_scancode_string(action_list[0].scancode)
			config.set_value("input", action_name, scancode)
		config.save(CONFIG_FILE)
