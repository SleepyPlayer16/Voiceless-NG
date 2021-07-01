extends Node
onready var savedataa = get_node("../../../MainMenuScreen")

func process_command(input: String):
	#return "the game"
	var words = input.split("",false)
	if words.size() == 0:
		return "Please insert a valid code"

	var first_word = words[0].to_lower()
	match(first_word):
		"0808":
			return unlockLiz()
		_:
			negative()
			return "Please insert a valid code"
		

func unlockLiz():
	if savedataa.data.user_data["liz_unlocked"] == false:
		savedataa.data.user_data["liz_unlocked"] = true
		savedataa.save_game()
		finish()
		return "Liz Unlocked!"
	else:
		negative()
		return "Liz has already been unlocked!"

func finish():
	var select_sound = AudioStreamPlayer.new()
	self.add_child(select_sound)
	select_sound.stream = load("res://sound_effect stuff/positive.wav")
	select_sound.play()
	yield (select_sound, "finished")
	select_sound.queue_free()

func negative():
	var select_sound = AudioStreamPlayer.new()
	self.add_child(select_sound)
	select_sound.stream = load("res://sound_effect stuff/sfx_cannotSelect.wav")
	select_sound.play()
	select_sound.set_volume_db(-5)
	yield (select_sound, "finished")
	select_sound.queue_free()	