extends Sprite2D

# Limites da área em pixels onde a mão pode se mover (Min X, Max X, Min Y, Max Y)
@export var min_limit: Vector2 = Vector2(400, 300)
@export var max_limit: Vector2 = Vector2(1500, 800)

# Velocidade de resposta da mão (quanto maior, mais rápida ela segue o ponteiro)
@export var follow_speed: float = 18.0

func _process(delta: float) -> void:
	# 1. Pega a posição global atual do cursor do mouse
	var real_mouse_pos: Vector2 = get_global_mouse_position()
	
	# 2. Restringe a posição do mouse aos limites mínimos e máximos definidos
	var clamped_target: Vector2 = Vector2(
		clamp(real_mouse_pos.x, min_limit.x, max_limit.x),
		clamp(real_mouse_pos.y, min_limit.y, max_limit.y)
	)
	
	# 3. Move a mão suavemente até a posição limitada
	global_position = global_position.lerp(clamped_target, follow_speed * delta)
