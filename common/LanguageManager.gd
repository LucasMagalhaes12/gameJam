extends Node

var current_language_index:int = 1
var languages = ["en", "pt_BR"]


func _ready() -> void:
	await get_tree().process_frame
	if SaveManager.user_settings.has("language_index"):
		current_language_index = SaveManager.user_settings["language_index"]
	else:
		current_language_index = _get_system_language_index()
	if current_language_index < 0 or current_language_index >= languages.size():
		current_language_index = 0
	_apply_language()


func next_language():
	current_language_index = (current_language_index + 1) % languages.size()
	SaveManager.user_settings["language_index"] = current_language_index
	SaveManager.save_settings()
	_apply_language()
	

func _apply_language() -> void:
	TranslationServer.set_locale(languages[current_language_index])


func _get_system_language_index() -> int:
	var system_locale: String = OS.get_locale()
	var exact_index: int = languages.find(system_locale)
	if exact_index != -1:
		return exact_index
	var system_lang: String = OS.get_locale_language()
	for i in range(languages.size()):
		if languages[i].begins_with(system_lang):
			return i
	return 1
