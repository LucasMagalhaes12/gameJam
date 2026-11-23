extends Control


func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed() and not event.is_echo():
			_go_to_next_scene()


func _go_to_next_scene() -> void:
	set_process_input(false)
	SceneTransition.change_scene("res://src/levels/level_1.tscn")
	#get_tree().change_scene_to_file("res://src/levels/level_1.tscn")
