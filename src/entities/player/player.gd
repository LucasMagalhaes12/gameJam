extends CharacterBody2D

@export var speed: float = 60.0
@export var flashlight_turn_speed: float = 8.5

@onready var aura_light: PointLight2D = $AuraLight
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var flashlight_pivot: Node2D = $FlashlightPivot
@onready var flashlight: PointLight2D = $FlashlightPivot/Flashlight

var can_move: bool = true
var base_energy: float = 1.2


func _ready() -> void:
	base_energy = flashlight.energy


func _physics_process(delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		return

	_handle_movement()
	_handle_flashlight(delta)


func _handle_movement() -> void:
	# Funciona com setas (ui_*) e WASD se configurados no Mapa de Entrada
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	move_and_slide()


func _handle_flashlight(delta: float) -> void:
	var target_angle := (get_global_mouse_position() - flashlight_pivot.global_position).angle()
	flashlight_pivot.rotation = lerp_angle(
		flashlight_pivot.rotation,
		target_angle,
		flashlight_turn_speed * delta
	)
	
	# Faz o sprite girar junto com a lanterna
	sprite.rotation = flashlight_pivot.rotation
	aura_light.rotation = flashlight_pivot.rotation
	# Oscilação sutil na energia para simular uma lanterna real
	if flashlight.visible:
		flashlight.energy = base_energy + randf_range(-0.05, 0.05)


func _unhandled_input(event: InputEvent) -> void:
	if not can_move:
		return

	# Permite ligar/desligar a lanterna com o botão direito do mouse
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		flashlight.visible = not flashlight.visible
