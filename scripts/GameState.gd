extends Node

# Autoload singleton to track round state across scene reloads

var current_round : int = 1
var max_rounds : int = 3
var p1_round_wins : int = 0
var p2_round_wins : int = 0

var bg_music_player : AudioStreamPlayer = null

func _ready():
	# Create persistent background music
	bg_music_player = AudioStreamPlayer.new()
	bg_music_player.stream = load("res://assets/audio/videoplayback.mp3")
	bg_music_player.volume_db = -10.0
	bg_music_player.bus = "Master"
	add_child(bg_music_player)
	bg_music_player.finished.connect(_on_music_finished)
	bg_music_player.play()

func _on_music_finished():
	# Loop the music
	bg_music_player.play()

func reset():
	current_round = 1
	p1_round_wins = 0
	p2_round_wins = 0
