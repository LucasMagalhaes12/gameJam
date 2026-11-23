extends Control

@onready var slot_1_label: Label = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Slot1 Label"
@onready var slot_2_label: Label = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Slot2 Label"
@onready var slot_3_label: Label = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Slot3 Label"

@onready var slot_1_btn: Button = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Slot1 Btn"
@onready var slot_2_btn: Button = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Slot2 Btn"
@onready var slot_3_btn: Button = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Slot3 Btn"

@onready var slot_1_delete_btn: Button = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Slot1Delete Btn"
@onready var slot_2_delete_btn: Button = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Slot2Delete Btn"
@onready var slot_3_delete_btn: Button = $"TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Slot3Delete Btn"

@onready var back: Button = $TextureRect/MarginContainer/VBoxContainer/Back



func _ready() -> void:
	slot_1_btn.grab_focus()
	slot_1_btn.pressed.connect(_on_slot_selected.bind(1))
	slot_2_btn.pressed.connect(_on_slot_selected.bind(2))
	slot_3_btn.pressed.connect(_on_slot_selected.bind(3))
	slot_1_delete_btn.pressed.connect(_on_delete_save.bind(1))
	slot_2_delete_btn.pressed.connect(_on_delete_save.bind(2))
	slot_3_delete_btn.pressed.connect(_on_delete_save.bind(3))
	back.pressed.connect(_on_back)
	_update_slot_btns()
	_update_slot_label()
	_setup_button_focus(self)



func _update_slot_label() -> void:
	slot_1_label.text = tr("KEY_SLOT") % 1
	slot_2_label.text = tr("KEY_SLOT") % 2
	slot_3_label.text = tr("KEY_SLOT") % 3


func _update_slot_btns() -> void:
	var main_btn = [slot_1_btn, slot_2_btn, slot_3_btn]
	var delete_btn = [slot_1_delete_btn, slot_2_delete_btn, slot_3_delete_btn]
	for i in range(1, 4):
		if SaveManager.slot_has_save(i):
			main_btn[i - 1].text = "%s" % tr("KEY_SLOT_SAVED")
			#main_btn[i - 1].text = "Slot %d (%s)" % [i, tr("KEY_SLOT_SAVED")]
			delete_btn[i - 1].disabled = false
		else:
			main_btn[i - 1].text = "%s" % tr("KEY_SLOT_EMPTY")
			#main_btn[i - 1].text = "Slot %d (%s)" % [i, tr("KEY_SLOT_EMPTY")]
			delete_btn[i - 1].disabled = true


func _on_slot_selected(slot_id: int) -> void:
	set_process_input(false)
	if SaveManager.slot_has_save(slot_id):
		SaveManager.load_game(slot_id)
	else:
		SaveManager.create_new_save(slot_id)
	_update_slot_btns()
	set_process_input(false)
	SceneTransition.change_scene("res://src/levels/introduction/introduction.tscn")
	#get_tree().change_scene_to_file("res://src/levels/introduction.tscn")


func _on_delete_save(id:int) -> void:
	SaveManager.delete_save(id)
	_update_slot_btns()


func _setup_button_focus(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			child.mouse_entered.connect(func(): child.grab_focus())
		if child.get_child_count() > 0:
			_setup_button_focus(child)


func _on_back() -> void: 
	set_process_input(false)
	SceneTransition.change_scene("res://src/ui/menus/main_menu/main_menu.tscn")
	#get_tree().change_scene_to_file("res://src/ui/menus/main_menu/main_menu.tscn")
