extends AudioStreamPlayer

export var bpm := 135
var actualbpm = 1
var safezone = 0
var safezone2 = 0

var offset_path = "user://data.json"


var songpos = 0.00
var comparer = 0.0
var comparer2  = 0.0
var securezone = true
var safedata
var comparer_behind = 0.00
var comparer_front = 0.00

var time = 0.00
var time2 = 0.00
var half_beat = 0
var half_beatTwo = 0
var bps = 1.00
var beat_num = 1
var songPosInBeats = 1
var msCalc = 1000
var _hbps = bps * 1 # half beats per second
var _last_half_beat = 0
var _last_half_beatTwo = 0
var actualoffset= 0.000
var offset_type = 0 # 0 is normal, 1 is negative
var offset=0.000
var offset_done = false
var song_start_delay = 1.000
var song = null
var songPosition = 0.0
var songLength = null
var beat_signal = false
var time_delay
var deltaa 
var menu_song = 0 
var spawn_once = false
onready var realplayer = $ActualPlayer
onready var guinote = get_node("../Rythm")
#onready var note = get_node("../Rythm/Control")

func play_audio() -> void:
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	
	yield(get_tree().create_timer(time_delay), "timeout")
	play()
	
func _ready():
	randomize()
	var song_rando
	song_rando = randi() % 2
	if song_rando == 1:
		song_data("res://Music/mus_menu.ogg",115,-5,60.0)
		menu_song = 1
	else: 
		song_data("res://Music/mus_tutorialAlt.ogg",124,-2,60.0)
		menu_song = 2
	play_audio()
	volume_db = -180
	songLength=stream.get_length()

func _process(_delta):
	deltaa = _delta
	bps = 60.0 / actualbpm
	_hbps = bps * 1
	#print(offset)
	safezone+=bps
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

	if offset_type == 1:	
			var offsetnegative = ((offset*-1)*_delta)*60
			
			if time >= offsetnegative and offset_done == false:
				$ActualPlayer.volume_db = -5
				$ActualPlayer.play_audio(0.000)
				offset_done = true

		#if (offset >= actualoffset+time_delay) and offset_done == false:
				#$ActualPlayer.play_audio(0.000)
				#offset_done = true
	elif offset_type == 0:
		if offset_done == false:
			offset_done = true
			$ActualPlayer.play_audio(offset)
			



	half_beat = int(time / _hbps)
	if half_beat > _last_half_beat:

		_last_half_beat = half_beat
		beat_signal = true
		guinote.spawn_note()
		safezone2 = safezone
		safezone = 0
		songPosInBeats+=1
	if time < bps:
		_last_half_beat = 0
	if beat_num%2 == 0:
		player_boppin()
	time2 = (
		$ActualPlayer.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- AudioServer.get_output_latency()
	)
	half_beatTwo = int(time2 / _hbps)

	if half_beatTwo > _last_half_beatTwo:
		_last_half_beatTwo = half_beatTwo
		beat_num+=1
	if time2 < bps:
		_last_half_beatTwo = 0

func player_boppin():

	var playerAnimplayer=get_node("../Player/AnimationPlayer")
	var playerAnimplayerFrog=get_node("../Player/AnimationPlayer")

	var player = get_node ("../Player")
	
	if player.amIinTheFuckinAir == false and player.state == player.IDLE:
		playerAnimplayer.seek(1,true)
		playerAnimplayer.play("Idle")
		
		playerAnimplayerFrog.seek(0.4,true)
		playerAnimplayerFrog.play("Idle")
		
		#playerAnimplayerCustom.seek("1,true")
func restart_everything():
	actualbpm = 1

	songpos = 0.00
	comparer = 0.0
	comparer2  = 0.0
	securezone = true

	time = 0.00
	half_beat = 0
	half_beatTwo = 0

	beat_num = 1
	songPosInBeats = 1
	_hbps = bps * 1 # half beats per second
	_last_half_beat = 0
	_last_half_beatTwo = 0
	actualoffset= 0.000
	offset_type = 0 # 0 is normal, 1 is negative

	offset_done = false
	song_start_delay = 1.000
	songPosition = 0.0

	stop()
	$ActualPlayer.stop()
	if menu_song == 1:
		actualbpm = 115
	else:
		actualbpm = 124
	$ActualPlayer.volume_db = -5
	bps = 60.0 / actualbpm
	stream = song
	$ActualPlayer.stream = song
	
	play_audio()
	volume_db = -180
	
func song_data(mus,songbpm,volume,beatsps):#beatsps = beats per second
	song = load(mus)
	actualbpm = songbpm
	$ActualPlayer.volume_db = volume
	bps = beatsps / actualbpm
	stream = song
	$ActualPlayer.stream = song
	
func Securezone(_behind,_front,_maxbpm,_increment): #Si le mueves te voy a matar alv 
	#ytu quien eres we 
	songpos = get_playback_position()
	if comparer < songpos:
		comparer += (bps)
		comparer2 = (comparer - bps)
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