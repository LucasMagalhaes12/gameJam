extends Node


const SETTINGS_FILE_PATH: String = "user://settings.json"

var user_settings: Dictionary = {
	"language_index": 0,
	"current_resolution": "1920x1080"
}
var current_slot: int = 1

var default_game_data: Dictionary = {
	"day": 1,
	"anxiety_level": 0,
	#"player_name": "Jane Doe",
	"completed_calls": 0
}
var game_data: Dictionary = {}


func _ready() -> void:
	load_settings()


func save_settings() -> void:
	var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(user_settings)
		file.store_string(json_string)
		file.close()


func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		save_settings()
		return

	var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var loaded_data = json.get_data()
			if typeof(loaded_data) == TYPE_DICTIONARY:
				user_settings.merge(loaded_data, true)


func get_slot_file_path(slot_id: int) -> String:
	return "user://save_slot_%d.json" % slot_id


func slot_has_save(slot_id: int) -> bool:
	return FileAccess.file_exists(get_slot_file_path(slot_id))


func save_game(slot_id: int = current_slot) -> void:
	current_slot = slot_id
	var file_path = get_slot_file_path(current_slot)
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file:
		var json_string = JSON.stringify(game_data, "\t")
		file.store_string(json_string)
		file.close()
		print("Save Game Succefully: ", current_slot)


func load_game(slot_id: int) -> bool:
	current_slot = slot_id
	var file_path = get_slot_file_path(slot_id)
	
	if not slot_has_save(slot_id):
		return false
		
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		if json.parse(json_string) == OK:
			game_data = json.data
			print("Load Save game: ", current_slot)
			return true
	return false


func create_new_save(slot_id: int) -> void:
	game_data = default_game_data.duplicate(true)
	save_game(slot_id)


func delete_save(slot_id: int) -> bool:
	var file_path = get_slot_file_path(slot_id)
	if slot_has_save(slot_id):
		var error = DirAccess.remove_absolute(file_path)
		if error == OK:
			print("Slot Save %d Deleted!" % slot_id)
			return true
		else:
			print("Error Delete %d: %d" % [slot_id, error])
	return false
