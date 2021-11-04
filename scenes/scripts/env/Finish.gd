extends Area2D

export (String) var next_level
export (int) var number_of_level
export var boss = false
export (String) var boss_name

func _on_finish_body_entered(body):
	if body.is_in_group("player"):
		finish()

func finish():
	get_node("../Pause/Music").stop()
	var sound = get_node("Sounds/Win" + str(int(rand_range(1, 5))))
	sound.play()
	var enemies_killed = 0
	var bottles_collected = 0
	get_tree().paused = true
	$CanvasLayer/FinishContainer.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.warp_mouse_position(Vector2(640, 360))
	if not boss:
		enemies_killed = get_parent().enemies_killed
		bottles_collected = get_parent().bottles_collected
		$CanvasLayer/FinishContainer/Results/EnemiesKilled.text = \
			"Убито врагов: " + str(enemies_killed) + "/" + str(get_parent().ENEMIES_TOTAL)
		$CanvasLayer/FinishContainer/Results/BottlesCollected.text = \
			"Бутылок кумыса собрано: " + str(bottles_collected) + "/" + str(get_parent().BOTTLES_TOTAL)
	else:
		$CanvasLayer/FinishContainer/Results/EnemiesKilled.text = boss_name
		$CanvasLayer/FinishContainer/Results/BottlesCollected.text = "больше не угрожает Астане!"
	save_results(enemies_killed, bottles_collected)

func _on_next_level_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$CanvasLayer/FinishContainer.visible = false
	get_tree().paused = false
	if get_tree().change_scene("res://scenes/levels/" + next_level + ".tscn"):
		pass

func _on_quit_pressed():
	$CanvasLayer/FinishContainer.visible = false
	get_tree().paused = false
	if get_tree().change_scene("res://scenes/env/MainMenu.tscn"):
		pass

func save_results(var enemies_killed, var koumiss_collected):
	var store_dict = {"won":1, "enemies_killed":enemies_killed, "koumiss_collected":koumiss_collected}
	var save_file = File.new()
	if save_file.file_exists("user://AMBALevelResults" + str(number_of_level) + ".save"):
		save_file.open("user://AMBALevelResults" + str(number_of_level) + ".save", File.READ)
		var read_dict = parse_json(save_file.get_line())
		for i in read_dict.keys():
			if store_dict[i] < read_dict[i]:
				store_dict[i] = read_dict[i]
		save_file.close()
	save_file.open("user://AMBALevelResults" + str(number_of_level) + ".save", File.WRITE)
	save_file.store_line(to_json(store_dict))
	save_file.close()
