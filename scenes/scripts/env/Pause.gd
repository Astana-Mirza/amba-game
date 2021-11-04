extends CanvasLayer

var default_cursor = preload("res://scenes/textures/misc/default_cursor.png")
signal unpaused

func pause():
	Input.set_custom_mouse_cursor(default_cursor)
	Input.action_release("ui_cancel")
	get_tree().paused = true
	$PauseContainer.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.warp_mouse_position(Vector2(640, 360))

func _quit_pressed():
	get_tree().paused = false
	if get_tree().change_scene("res://scenes/env/MainMenu.tscn"):
		pass
	$PauseContainer.visible = false

func _continue_pressed():
	$PauseContainer.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.action_release("ui_cancel")
	get_tree().paused = false
	emit_signal("unpaused")

func _settings_pressed():
	var settings_res = preload("res://scenes/env/Settings.tscn")
	self.add_child(settings_res.instance())

func _restart_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if get_tree().reload_current_scene():
		pass

func apply_settings(var music_vol, var effects_vol):
	if music_vol <= -50:
		$Music.stop()
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_vol)
	if effects_vol <= -50:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), effects_vol)
