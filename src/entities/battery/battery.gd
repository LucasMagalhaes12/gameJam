extends Area2D

@export var recharge_amount: float = 35.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_battery"):
		body.add_battery(recharge_amount)
		queue_free()
