extends Node

signal resolution_changed(new_resolution_str: String)

var current_resolution_index: int = 0
#var current_resolution_index: int = get_current_resolution_id()

var is_fullscreen: bool = true

var resolutions: Array[Vector2i] = [
	Vector2i(1920, 1080),
	Vector2i(1600, 900),
	Vector2i(1366, 768),
	Vector2i(1280, 720),
	Vector2i(1024, 576)
	#Vector2i(320, 180)
	]


func _ready() -> void:
	if SaveManager.user_settings.has("resolution_index"):
		current_resolution_index = SaveManager.user_settings["resolution_index"]
	else:
		current_resolution_index = _get_native_resolution_index()
		
	if SaveManager.user_settings.has("fullscreen"):
		is_fullscreen = SaveManager.user_settings["fullscreen"]

	if current_resolution_index < 0 or current_resolution_index >= resolutions.size():
			current_resolution_index = 0
	#await get_tree().process_frame
	_apply_settings()
	
	
func get_current_resolution_string() -> String:
	var res = resolutions[current_resolution_index]
	return "%dx%d" % [res.x, res.y]


func next_resolution() -> void:
	current_resolution_index = (current_resolution_index + 1) % resolutions.size()
	SaveManager.user_settings["resolution_index"] = current_resolution_index
	SaveManager.save_settings()
	_apply_settings()


func toggle_fullscreen() -> void:
	is_fullscreen = !is_fullscreen
	SaveManager.user_settings["fullscreen"] = is_fullscreen
	SaveManager.save_settings()
	_apply_settings()


func _get_native_resolution_index() -> int:
	var screen_id: int = get_window().current_screen
	var native_size: Vector2i = DisplayServer.screen_get_size(screen_id)
	var index: int = resolutions.find(native_size)
	if index != -1:
		return index

	for i in range(resolutions.size()):
		if resolutions[i].x <= native_size.x and resolutions[i].y <= native_size.y:
			return i

	return 0



func _apply_settings() -> void:
	if Engine.is_editor_hint() or DisplayServer.get_name() == "headless":
		return
	var main_window: Window = get_window()
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#main_window.mode = Window.MODE_FULLSCREEN
	else:
		#main_window.mode = Window.MODE_WINDOWED
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		var res: Vector2i = resolutions[current_resolution_index]
		#DisplayServer.window_set_size(res)
		main_window.size = res
		#get_tree().root.content_scale_size = res
		var screen_id: int = main_window.current_screen
		var screen_rect: Rect2i = DisplayServer.screen_get_usable_rect(screen_id)
		var window_position: Vector2i = screen_rect.position + (screen_rect.size - res) / 2
		DisplayServer.window_set_position(window_position)
		#main_window.position = window_position
		
	#await get_tree().create_timer(0.05).timeout
	#get_tree().root.propagate_notification(NOTIFICATION_WM_SIZE_CHANGED)
	#resolution_changed.emit(get_current_resolution_string())
	#await get_tree().process_frame
	resolution_changed.emit(get_current_resolution_string())
