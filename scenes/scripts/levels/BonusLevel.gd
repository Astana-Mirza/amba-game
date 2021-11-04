extends GameLevel

var charname = "Арыстанчабан"

func _on_dialogue_finished():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if get_tree().change_scene("res://scenes/env/MainMenu.tscn"):
		pass
