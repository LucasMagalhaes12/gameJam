class_name NoteReader
extends CanvasLayer

signal note_closed(note_id: String)

@onready var audio_note: AudioStreamPlayer2D = $AudioNote

@onready var dim_bg: ColorRect = $DimBackground
@onready var paper_panel: PanelContainer = $PaperPanel
@onready var title_label: Label = $PaperPanel/MarginContainer/VBoxContainer/TitleLabel
@onready var content_label: RichTextLabel = $PaperPanel/MarginContainer/VBoxContainer/ContentLabel

var current_note_id: String = ""
var read_notes: Array[String] = []


func _ready() -> void:
	add_to_group("note_reader")
	_set_ui_visible(false)


func _input(event: InputEvent) -> void:
	if not paper_panel.visible:
		return

	if event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close_note()


func open_note(note_id: String, title: String, content: String) -> void:
	if paper_panel.visible:
		return

	current_note_id = note_id
	title_label.text = title
	content_label.text = content
	_set_ui_visible(true)
	_set_player_movement(false)
	audio_note.play()

	if note_id not in read_notes:
		read_notes.append(note_id)


func close_note() -> void:
	audio_note.play()
	_set_ui_visible(false)
	_set_player_movement(true)
	note_closed.emit(current_note_id)


func _set_ui_visible(state: bool) -> void:
	dim_bg.visible = state
	paper_panel.visible = state


func _set_player_movement(enabled: bool) -> void:
	var player := get_tree().get_first_node_in_group("player") as Player
	if player:
		player.can_move = enabled
