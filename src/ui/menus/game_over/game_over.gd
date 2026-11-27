class_name GameOver
extends CanvasLayer


@onready var retry_button: Button = $CenterContainer/VBoxContainer/RetryButton
@onready var menu_button: Button = $CenterContainer/VBoxContainer/MenuButton


func _ready() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	retry_button.grab_focus()


func _on_retry_pressed() -> void:
	_disable_buttons()
	AudioManager.play_click()
	SceneTransition.change_scene("res://src/levels/level/game.tscn")


func _on_menu_pressed() -> void:
	_disable_buttons()
	AudioManager.play_click()
	SceneTransition.change_scene("res://src/ui/menus/main_menu/main_menu.tscn")


func _disable_buttons() -> void:
	retry_button.disabled = true
	menu_button.disabled = true
