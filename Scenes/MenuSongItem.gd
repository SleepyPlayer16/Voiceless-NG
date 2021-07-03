extends Node2D

#0-Tutorial
#1-SolarPunk
#2-Ice
#3-Forest

var worldNumber = 1
var songNumber = 1
var rank = 0
var death = 1
onready var backgroundImage = $BackgroundImage
onready var songName = $BackgroundImage/SongName
onready var rankingSprite = $BackgroundImage/Ranking
onready var deathRank = $BackgroundImage/NoDeathRanking

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rankingSprite.frame = rank
	match(death):
		0:
			deathRank.visible = false
		1:
			deathRank.visible = true

	if worldNumber < 1:
		worldNumber = 1

	if songNumber < 1:
		songNumber = 1

	if songNumber > 3:
		songNumber = 3

	if death > 1:
		death = 1
	
	if death < 0:
		death = 0
	
	if rank > 6:
		rank = 6
	
	if rank < 0:
		rank = 0

	match(worldNumber):
		0:
			songImageData(
				load("res://sprites/song_selectionMenu/SongImages/Tutorial/spr_worldTutorialSong.png"),
				load("res://sprites/song_selectionMenu/SongImages/Tutorial/Tutorial.png")
			)
		1:
			songImageData(
				load("res://sprites/song_selectionMenu/SongImages/World1/spr_world1Songs.png"),
				load("res://sprites/song_selectionMenu/SongImages/World1/song"+str(songNumber)+".png")
			)
		2:
			songImageData(
				load("res://sprites/song_selectionMenu/SongImages/World2/spr_world2Songs.png"),
				load("res://sprites/song_selectionMenu/SongImages/World2/song"+str(songNumber)+".png")
			)
		3:
			songImageData(
				load("res://sprites/song_selectionMenu/SongImages/World3/spr_world3Songs.png"),
				load("res://sprites/song_selectionMenu/SongImages/World3/song"+str(songNumber)+".png")
			)

func songImageData(_backImage,_songNameImage):
	backgroundImage.texture = _backImage
	songName.texture = _songNameImage
