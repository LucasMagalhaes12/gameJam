extends Control

@onready var play_game: Button = $"MarginContainer/VBoxContainer/Play Game"
@onready var settings: Button = $MarginContainer/VBoxContainer/Settings
@onready var credits: Button = $MarginContainer/VBoxContainer/Credits
@onready var exit: Button = $MarginContainer/VBoxContainer/Exit


func _ready() -> void:
	play_game.grab_focus()

	play_game.pressed.connect(_on_play_game_pressed)
	settings.pressed.connect(_on_settings_pressed)
	credits.pressed.connect(_on_credits_pressed)
	exit.pressed.connect(_on_exit_pressed)
	_setup_button_focus(self)

func _on_play_game_pressed() -> void:
	set_process_input(false)
	get_tree().change_scene_to_file("res://src/ui/menus/new_game/new_game.tscn")


func _on_settings_pressed() -> void:
	set_process_input(false)
	get_tree().change_scene_to_file("res://src/ui/menus/settings/settings.tscn")


func _on_credits_pressed() -> void:
	set_process_input(false)
	get_tree().change_scene_to_file("res://src/ui/menus/credits/credits.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _setup_button_focus(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			child.mouse_entered.connect(func(): child.grab_focus())
		
		if child.get_child_count() > 0:
			_setup_button_focus(child)
