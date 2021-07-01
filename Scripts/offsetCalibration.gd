extends Node2D

var ms = 1
var offset = 0.000
var timer = 0
onready var savedata = get_node("../MainMenuScreen")
onready var rhythm_indicator = get_node("../Rythm/rhythm_container")
onready var audio = get_node("../AudioStreamPlayer2")
onready var audioTwo = get_node("../AudioStreamPlayer2/ActualPlayer")
# Called when the node enters the scene tree for the first time.
func _ready():
	offset = savedata.data.user_data["offset"]
	$visual_offset_arrow_selector.position.x = offset*1000
	print(position.x)


func _process(_delta):
	$RichTextLabel.set_text(str(offset).pad_decimals(3))
	if visible:
		if savedata.data.user_data["sfx_active"] == false:
			$spr_muteicon.frame = 1
		else:
			$spr_muteicon.frame = 0
		rhythm_indicator.visible = true
		if Input.is_action_just_pressed("mute"):
			if $spr_muteicon.frame == 0:
				savedata.data.user_data["sfx_active"] = false
				savedata.save_game()
				$spr_muteicon.frame = 1
			else:
				savedata.data.user_data["sfx_active"] = true
				savedata.save_game()
				$spr_muteicon.frame = 0

		if Input.is_action_just_pressed("saveoffset"):

			savedata.data.user_data["offset"] = offset
			savedata.save_game()
			audio.offset=savedata.data.user_data["offset"]
			audio.restart_everything()
			print(audio.offset)
			print (savedata.data)
		if Input.is_action_pressed("ui_right"):
			timer+=(1*_delta)*60
			if timer >= 20:
				if $visual_offset_arrow_selector.position.x < 290:
					$visual_offset_arrow_selector.position.x += 1
					offset = $visual_offset_arrow_selector.position.x/1000
					print(offset)
				else:
					$visual_offset_arrow_selector.position.x = 290

		if Input.is_action_pressed("ui_left"):
			timer+=1
			if timer >= 20:
				if $visual_offset_arrow_selector.position.x > -290:
					$visual_offset_arrow_selector.position.x -= 1
					offset = $visual_offset_arrow_selector.position.x/1000
					print(offset)
				else:
					$visual_offset_arrow_selector.position.x = -290
					
		if Input.is_action_just_released("ui_right"):
			timer = 0
		if Input.is_action_just_released("ui_left"):
			timer = 0
			
		if Input.is_action_just_pressed("ui_right"):
			if $visual_offset_arrow_selector.position.x < 290:
				$visual_offset_arrow_selector.position.x += 1
				offset = $visual_offset_arrow_selector.position.x/1000
				print(offset)
			else:
				$visual_offset_arrow_selector.position.x = 290

		elif Input.is_action_just_pressed("ui_left"):
			if $visual_offset_arrow_selector.position.x > -290:
				$visual_offset_arrow_selector.position.x -= 1
				offset = $visual_offset_arrow_selector.position.x/1000
				print(offset)
			else:
				$visual_offset_arrow_selector.position.x = -290
	else:
		rhythm_indicator.visible = false
