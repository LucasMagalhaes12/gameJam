extends Node

var click_player: AudioStreamPlayer
var click_stream: AudioStream = preload("res://assets/sfx/selection/Menu Selection Click.wav") # ajuste o nome do arquivo


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	click_player = AudioStreamPlayer.new()
	click_player.stream = click_stream
	click_player.max_polyphony = 4
	add_child(click_player)


func play_click() -> void:
	click_player.play()
