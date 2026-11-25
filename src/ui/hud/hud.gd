class_name HUD
extends CanvasLayer

@onready var battery_bar: ProgressBar = $MarginContainer/VBoxContainer/BatteryBar
@onready var fear_bar: ProgressBar = $MarginContainer/VBoxContainer/FearBar


func _ready() -> void:
	add_to_group("hud")


func update_battery(value: float, max_value: float) -> void:
	battery_bar.max_value = max_value
	battery_bar.value = value


func update_fear(value: float, max_value: float) -> void:
	fear_bar.max_value = max_value
	fear_bar.value = value
