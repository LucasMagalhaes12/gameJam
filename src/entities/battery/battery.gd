class_name BatteryPickup
extends Area2D

@export var recharge_amount: float = 35.0

var is_collected: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if is_collected or not body.has_method("add_battery"):
		return

	if body.add_battery(recharge_amount):
		is_collected = true
		set_deferred("monitoring", false)
		queue_free()
