class_name Note
extends Area2D

@export var note_id: String = "NOTE_01"

@onready var prompt_label: Label = $PromptLabel

var player_ref: Player = null


func _ready() -> void:
	prompt_label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
	if player_ref == null or not player_ref.can_move:
		return

	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		get_tree().call_group(
			"note_reader",
			"open_note",
			note_id,
			tr("%s_TITLE" % note_id),
			tr("%s_CONTENT" % note_id)
		)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_ref = body
		prompt_label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body == player_ref:
		player_ref = null
		prompt_label.visible = false
