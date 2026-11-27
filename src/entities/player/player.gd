class_name Player
extends CharacterBody2D

signal panic_triggered

@export var speed: float = 60.0
@export var flashlight_turn_speed: float = 8.5
@onready var audio_flashlight: AudioStreamPlayer2D = $AudioFlashlight
@onready var footstep_sound: AudioStreamPlayer2D = $FootstepSound

var step_interval: float = 0.45
var step_timer: float = 0.0

@export_group("Lanterna e Medo")
@export var max_battery: float = 100.0
@export var battery_drain_rate: float = 4.0
@export var max_fear: float = 100.0
@export var fear_drain_rate: float = 7.0
@export var fear_regen_rate: float = 3.0

@onready var aura_light: PointLight2D = $AuraLight
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var flashlight_pivot: Node2D = $FlashlightPivot
@onready var flashlight: PointLight2D = $FlashlightPivot/Flashlight
@onready var flashlight_area: Area2D = get_node_or_null("FlashlightPivot/FlashlightArea")

var can_move: bool = true:
	set(value):
		can_move = value
		if not can_move:
			velocity = Vector2.ZERO

var base_energy: float = 1.2
var has_panicked: bool = false

var current_battery: float:
	set(value):
		var clamped := clampf(value, 0.0, max_battery)
		if is_equal_approx(current_battery, clamped):
			return
		current_battery = clamped
		get_tree().call_group("hud", "update_battery", current_battery, max_battery)

var current_fear: float:
	set(value):
		var clamped := clampf(value, 0.0, max_fear)
		if is_equal_approx(current_fear, clamped):
			return
		current_fear = clamped
		get_tree().call_group("hud", "update_fear", current_fear, max_fear)


func _ready() -> void:
	add_to_group("player")
	base_energy = flashlight.energy
	current_battery = max_battery
	current_fear = max_fear
	_set_flashlight(flashlight.visible)


func _physics_process(delta: float) -> void:
	if not can_move:
		return

	_handle_movement()
	_handle_flashlight(delta)
	_handle_footsteps(delta)


func _process(delta: float) -> void:
	if not can_move:
		return

	if flashlight.visible:
		_update_battery(delta)
		_recover_fear(delta)
	else:
		_drain_fear(delta)


func _unhandled_input(event: InputEvent) -> void:
	if not can_move:
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if not flashlight.visible and current_battery <= 0.0:
			return
		_set_flashlight(not flashlight.visible)
		audio_flashlight.play()


func add_battery(amount: float) -> bool:
	if current_battery >= max_battery:
		return false

	current_battery += amount
	return true


func _handle_movement() -> void:
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

	sprite.rotation = flashlight_pivot.rotation
	aura_light.rotation = flashlight_pivot.rotation

	if flashlight.visible:
		flashlight.energy = base_energy + randf_range(-0.05, 0.05)


func _update_battery(delta: float) -> void:
	current_battery -= battery_drain_rate * delta
	if current_battery <= 0.0:
		_set_flashlight(false)


func _recover_fear(delta: float) -> void:
	current_fear += fear_regen_rate * delta
	if current_fear > 0.0:
		has_panicked = false


func _drain_fear(delta: float) -> void:
	current_fear -= fear_drain_rate * delta
	if current_fear <= 0.0 and not has_panicked:
		has_panicked = true
		panic_triggered.emit()
		SceneTransition.change_scene("res://src/ui/menus/game_over/game_over.tscn")


func _set_flashlight(active: bool) -> void:
	flashlight.visible = active
	if flashlight_area:
		flashlight_area.monitorable = active


func _handle_footsteps(delta: float) -> void:
	if can_move and velocity.length() > 10.0:
		step_timer -= delta
		if step_timer <= 0.0:
			footstep_sound.play()
			step_timer = step_interval
	else:
		# Pequeno atraso inicial para evitar spam se o jogador der toques curtos no teclado
		step_timer = 0.15
