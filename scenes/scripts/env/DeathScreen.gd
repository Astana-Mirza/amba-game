extends CanvasLayer

func death():
	get_parent().get_node("Pause/Music").stop()
	var sound = get_node("Sounds/Death" + str(int(rand_range(1, 10))))
	sound.play()
	Input.action_release("ui_cancel")
	get_tree().paused = true
	$DeathScreenContainer.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.warp_mouse_position(Vector2(640, 360))

func _quit_pressed():
	get_tree().paused = false
	if get_tree().change_scene("res://scenes/env/MainMenu.tscn"):
		pass
	$DeathScreenContainer.visible = false

func _restart_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if get_tree().reload_current_scene():
		pass
