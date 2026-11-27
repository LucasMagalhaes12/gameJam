class_name HUD
extends CanvasLayer

@onready var battery_bar: ProgressBar = $MarginContainer/VBoxContainer/BatteryBar
@onready var fear_bar: ProgressBar = $MarginContainer/VBoxContainer/FearBar
@onready var sanity_vignette: ColorRect = $SanityVignette # ajuste o caminho se chamar do player.gd

func _ready() -> void:
	add_to_group("hud")


func update_battery(value: float, max_value: float) -> void:
	battery_bar.max_value = max_value
	battery_bar.value = value


func update_fear(value: float, max_value: float) -> void:
	fear_bar.max_value = max_value
	fear_bar.value = value

	var ratio: float = clamp(value / max_value, 0.0, 1.0)
	var mat := sanity_vignette.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("sanity_ratio", ratio)
