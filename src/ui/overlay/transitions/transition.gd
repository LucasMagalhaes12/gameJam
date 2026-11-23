extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

var _is_transitioning: bool = false


func _ready() -> void:
	# Garante que a transição funcione mesmo se o jogo estiver pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	color_rect.modulate.a = 0.0
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE


func change_scene(target_path: String, duration: float = 0.3) -> void:
	if _is_transitioning:
		return

	_is_transitioning = true
	# Bloqueia cliques acidentais durante a troca de tela
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP

	# Fade Out (escurece a tela)
	var fade_out := create_tween()
	fade_out.tween_property(color_rect, "modulate:a", 1.0, duration)
	await fade_out.finished

	# Troca a cena
	get_tree().change_scene_to_file(target_path)

	# Fade In (revela a nova tela)
	var fade_in := create_tween()
	fade_in.tween_property(color_rect, "modulate:a", 0.0, duration)
	await fade_in.finished

	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_is_transitioning = false
