extends AudioStreamPlayer

export var bpm := 135
var actualbpm = 1
var safezone = 0
var safezone2 = 0

var safedata

var path = "user://data.json"
var offset_path = "user://data.json"
var data = { }

var songpos = 0.00
var comparer = 0.0
var comparer2  = 0.0
var securezone = true
var deltat 

var comparer_behind = 0.00
var comparer_front = 0.00
var time = 0.00
var half_beat = 0
var half_beatTwo = 0
var bps = 1.00
var beat_num = 1
var songPosInBeats = 1
var msCalc = 1000
var _hbps = bps * 1 # half beats per second
var _last_half_beat := 0
var _last_half_beatTwo := 0
var actualoffset= 0.000
var spawn_once = true
var offset_type = 0 # 0 is normal, 1 is negative
var offset=0.000
var offset_done = false
var song_start_delay = 1.000
var song = null
var songPosition = 0.0
var songLength = null
var beat_signal = false
onready var guinote = get_node("../Rythm")
#onready var note = get_node("../Rythm/Control")

func play_audio() -> void:
	var time_delay := AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	
	yield(get_tree().create_timer(time_delay), "timeout")
	play()

func _ready():
	randomize()
	load_game()
	offset = data.user_data["offset"]

	match(get_tree().current_scene.name):
		"World":
			song_data("res://Music/mus_world1.ogg",135,-5,60.0)
		"World1-lvl2":
			song_data("res://Music/mus_world1-lvl2.ogg",140,-5,60.0)
		"World2":
			song_data("res://Music/mus_world2.ogg",160,-5,60.0)
		"World3":
			song_data("res://Music/mus_world3.ogg",165,-5,60.0)
		"tutoiral":
			song_data("res://Music/mus_tutorial.ogg",95,-5,60.0)


	play_audio()
	volume_db = -180
	songLength=stream.get_length()

func _process(_delta):
	deltat = _delta
	bps = 60.0 / actualbpm
	_hbps = bps * 1
	#print(offset)
	if beat_num > 4:
		beat_num = 1
	time = (
		self.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
	)

	if offset < actualoffset:
		offset_type = 1
	if offset >= actualoffset:
		offset_type = 0
	#offset negativo 
	if offset_type == 1:	
		var offsetnegative = ((offset*-1)*_delta)*60

		if time >= offsetnegative and offset_done == false:
			$ActualPlayer.volume_db = -5
			$ActualPlayer.play_audio(0.000)
			offset_done = true
	#
	#offset positivo
	elif offset_type == 0:
		if offset_done == false:
			offset_done = true
			$ActualPlayer.offset = offset
			$ActualPlayer.play_audio($ActualPlayer.offset)

	half_beat = int(time / _hbps)
	if half_beat > _last_half_beat:
		_last_half_beat = half_beat
		beat_signal = true
		guinote.spawn_note()
		songPosInBeats+=1
	if time < bps:
		_last_half_beat = 0

	#print("t ",time,"hb ",_last_half_beat)

	if beat_num%2 == 0:
		player_boppin()
	var time2 = (
		$ActualPlayer.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
	)
	half_beatTwo = int(time2 / _hbps)
	#Use this to ignore the global offset in objects
	#that change stuff to the beat, since they will sound out of
	#beat if the offset changes
	if half_beatTwo > _last_half_beatTwo:
		_last_half_beatTwo = half_beatTwo
		beat_num+=1
	if time2 < bps:
		_last_half_beatTwo = 0

func player_boppin():
	#This is the function that controls the player boppin their head to the beat
	#animation, just add a variable for your character below, 
	#You can name the Idle for your character however you want
	#I honestly do not remember what seek does in this script, i think it's
	#the frame where the animation will start playin' from
	var playerAnimplayer=get_node("../Player/AnimationPlayer")
	var playerAnimplayerFrog=get_node("../Player/AnimationPlayer2")
	var playerAnimplayerLiz=get_node("../Player/AnimationPlayer3")
	#var playerAnimplayerCustom=get_node("../Player/AnimationPlayer3")
	var player = get_node ("../Player")
	
	if player.amIinTheFuckinAir == false and player.state == player.IDLE || player.state == player.CONVERSATION:
		playerAnimplayer.seek(1,true)
		playerAnimplayer.play("Idle")
		
		playerAnimplayerFrog.seek(0.4,true)
		playerAnimplayerFrog.play("Idle")
		
		playerAnimplayerLiz.seek(1,true)
		playerAnimplayerLiz.play("Idle")
		#playerAnimplayerCustom.seek("1,true")
		#playerAnimplayerCustom.play("Idle")

#el increment aumenta la tolerancia intenta que no pase de 2 sino te moris
#max bpm es el bpm maximo que aguanta pendejo pa que preguntas ay estas bien baboso
#la de atras es el porcentaje de zona segura cuando la nota pasa del spot

#¿Qué putas chingadas madres dijiste de mí, pinche escuincle baboso? 
func Securezone(_behind,_front,_maxbpm,_increment): #Si le mueves te voy a matar alv 
	#ytu quien eres we 
	songpos = get_playback_position()
	if comparer < songpos:
		comparer += bps
		comparer2 = comparer - bps
	comparer_behind = (comparer-(bps*((_behind+(_front*((actualbpm*_increment)/_maxbpm)))/200.0)))
	comparer_front = comparer2+(bps*((_front+(_front*((actualbpm*_increment)/_maxbpm)))/200.0))
	safedata = (comparer_front-comparer_behind)+1

	if songpos > comparer_behind:
		securezone = true
	elif songpos <= comparer_front:
		securezone = true
	else:
		securezone = false
	if songpos < bps:
		comparer = 0
		comparer2 = 0
	return securezone

func song_data(mus,songbpm,volume,beatsps):#beatsps = beats per second
	song = load(mus)
	actualbpm = songbpm
	$ActualPlayer.volume_db = volume
	bps = beatsps / actualbpm
	stream = song
	$ActualPlayer.stream = song

func load_game():
	var file = File.new()

	file.open(path, file.READ)
	
	var text = file.get_as_text()
	
	data = parse_json(text)
	
	file.close()

