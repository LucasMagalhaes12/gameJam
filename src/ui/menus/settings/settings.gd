extends Control

@onready var fullscreen_btn: Button = $"MarginContainer/VBoxContainer/HBoxFullscreen/FullScreen Btn"
@onready var fullscreen_lb: Label = $"MarginContainer/VBoxContainer/HBoxFullscreen/FullScreen Lb"
@onready var resolution_btn: Button = $"MarginContainer/VBoxContainer/HBoxResolution/Resolution Btn"
@onready var resolution_lb: Label = $"MarginContainer/VBoxContainer/HBoxResolution/Resolution Lb"
@onready var language_btn: Button = $"MarginContainer/VBoxContainer/HBoxLanguage/Language Btn"
@onready var language_lb: Label = $"MarginContainer/VBoxContainer/HBoxLanguage/Language Lb"
@onready var back_btn: Button = $"MarginContainer/VBoxContainer/HBoxBack/Back Btn"


func _ready() -> void:
	resolution_btn.grab_focus()
	fullscreen_btn.pressed.connect(_on_fullscreen)
	resolution_btn.pressed.connect(_on_resolution)
	language_btn.pressed.connect(_on_language)
	back_btn.pressed.connect(_on_back)
	_update_ui()
	_setup_button_focus(self)


func _on_resolution() -> void:
	ScreenManager.next_resolution()
	resolution_lb.text = ScreenManager.get_current_resolution_string()


func _on_language() -> void:
	LanguageManager.next_language()
	_update_ui()


func _on_fullscreen() -> void:
	ScreenManager.toggle_fullscreen()
	_update_ui()


func _on_back() -> void:
	set_process_input(false)
	get_tree().change_scene_to_file("res://src/ui/menus/main_menu/main_menu.tscn")


func _update_ui() -> void:
	resolution_lb.text = ScreenManager.get_current_resolution_string()
	if ScreenManager.is_fullscreen:
		fullscreen_lb.text = tr("KEY_ON")
	else:
		fullscreen_lb.text = tr("KEY_OFF")


func _setup_button_focus(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			child.mouse_entered.connect(func(): child.grab_focus())
		
		if child.get_child_count() > 0:
			_setup_button_focus(child)
