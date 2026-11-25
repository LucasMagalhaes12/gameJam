extends CharacterBody2D

signal panic_triggered

@export var speed: float = 60.0
@export var flashlight_turn_speed: float = 8.5

@export_group("Lanterna e Medo")
@export var max_battery: float = 100.0
@export var battery_drain_rate: float = 4.0 # Quanto gasta por segundo ligada
@export var max_fear: float = 100.0
@export var fear_drain_rate: float = 7.0    # Quanto desce por segundo no escuro
@export var fear_regen_rate: float = 3.0    # Quanto recupera por segundo com luz

@onready var aura_light: PointLight2D = $AuraLight
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var flashlight_pivot: Node2D = $FlashlightPivot
@onready var flashlight: PointLight2D = $FlashlightPivot/Flashlight
@onready var flashlight_area: Area2D = get_node_or_null("FlashlightPivot/FlashlightArea")

var can_move: bool = true
var base_energy: float = 1.2
var current_battery: float
var current_fear: float
var has_panicked: bool = false


func _ready() -> void:
	base_energy = flashlight.energy
	current_battery = max_battery
	current_fear = max_fear
	_set_flashlight(flashlight.visible)
	_sync_hud()


func _physics_process(delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		return

	_handle_movement()
	_handle_flashlight(delta)


func _process(delta: float) -> void:
	if not can_move:
		return

	if flashlight.visible:
		# Consome bateria enquanto a lanterna está ligada
		current_battery = max(0.0, current_battery - battery_drain_rate * delta)
		if current_battery <= 0.0:
			_set_flashlight(false)

		# Recupera a sanidade gradualmente com a luz acesa
		current_fear = min(max_fear, current_fear + fear_regen_rate * delta)
		if current_fear > 0.0:
			has_panicked = false
	else:
		# Reduz a barra no escuro
		current_fear = max(0.0, current_fear - fear_drain_rate * delta)
		if current_fear <= 0.0 and not has_panicked:
			has_panicked = true
			panic_triggered.emit()

	_sync_hud()


func _unhandled_input(event: InputEvent) -> void:
	if not can_move:
		return

	# Liga ou desliga a lanterna com o botão direito do mouse
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if not flashlight.visible and current_battery <= 0.0:
			return

		_set_flashlight(not flashlight.visible)


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


func add_battery(amount: float) -> void:
	current_battery = clamp(current_battery + amount, 0.0, max_battery)
	_sync_hud()


func _set_flashlight(active: bool) -> void:
	flashlight.visible = active
	if flashlight_area:
		flashlight_area.monitorable = active


func _sync_hud() -> void:
	get_tree().call_group("hud", "update_battery", current_battery, max_battery)
	get_tree().call_group("hud", "update_fear", current_fear, max_fear)
