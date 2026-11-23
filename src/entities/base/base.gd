extends Control


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed() and not event.is_echo():
			get_tree().quit()


func _on_area_2d_area_entered(area: Area2D, extra_arg_0: NodePath) -> void:
	pass # Replace with function body.
