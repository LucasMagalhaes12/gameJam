extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed() and not event.is_echo():
			_go_to_next_scene()


func _on_animation_finished(_anim_name: String) -> void:
	_go_to_next_scene()



func _go_to_next_scene() -> void:
	set_process_input(false)
	get_tree().change_scene_to_file("res://src/ui/splash_screens/warning/warning.tscn")
