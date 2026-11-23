extends CharacterBody2D

@export var follow_speed: float = 20.0
@export var target_area: Area2D

var is_active: bool = false

func _process(delta: float) -> void:
	if not is_active or not is_instance_valid(target_area):
		return
	
	var col_shape: CollisionShape2D = target_area.get_node_or_null("CollisionShape2D")
	if not col_shape or not col_shape.shape is RectangleShape2D:
		return

	var mouse_pos: Vector2 = get_global_mouse_position()
	var rect_shape: RectangleShape2D = col_shape.shape
	var extents: Vector2 = rect_shape.size / 2.0
	var center: Vector2 = col_shape.global_position

	# Restringe o movimento dentro dos limites da caixa da Area2D
	var clamped_x: float = clamp(mouse_pos.x, center.x - extents.x, center.x + extents.x)
	var clamped_y: float = clamp(mouse_pos.y, center.y - extents.y, center.y + extents.y)

	global_position = global_position.lerp(Vector2(clamped_x, clamped_y), follow_speed * delta)
