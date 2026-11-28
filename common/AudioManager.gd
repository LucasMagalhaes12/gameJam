extends Node

var click_player: AudioStreamPlayer
var intro_menu: AudioStreamPlayer
var click_stream: AudioStream = preload("res://assets/sfx/selection/Menu Selection Click.wav") # ajuste o nome do arquivo
var intro_stream: AudioStream = preload("res://assets/music/intro.wav")

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	click_player = AudioStreamPlayer.new()
	click_player.stream = click_stream
	click_player.max_polyphony = 4
	add_child(click_player)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	intro_menu = AudioStreamPlayer.new()
	intro_menu.stream = intro_stream
	intro_menu.max_polyphony = 4
	add_child(intro_menu)


func play_click() -> void:
	click_player.play()


func play_intro() -> void:
	intro_menu.play()
