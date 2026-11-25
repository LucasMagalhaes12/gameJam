extends Area2D

@export var note_id: String = "NOTE_01"

@onready var prompt_label: Label = $PromptLabel

var player_in_range: bool = false


func _ready() -> void:
	prompt_label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		var translated_title := tr(note_id + "_TITLE")
		var translated_content := tr(note_id + "_CONTENT")
		get_tree().call_group("note_reader", "open_note", note_id, translated_title, translated_content)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = true
		prompt_label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false
		prompt_label.visible = false
