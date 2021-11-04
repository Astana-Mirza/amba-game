extends GameSaveNode

var cursor = preload("res://scenes/textures/misc/default_cursor.png")

const LEVELS_TOTAL = 13
var settings_res = preload("res://scenes/env/Settings.tscn")
var level_select_res = preload("res://scenes/env/LevelSelector.tscn")

func _ready():
	Input.set_custom_mouse_cursor(cursor)
	read_game_parameters()
	apply_settings()
	if music_vol > -50:
		$Music.play()

func _new_game_pressed():
	$MainMenu/Items/Loading.visible = true
	var prev_game_file = File.new()
	if prev_game_file.file_exists("user://AMBASecretSettings.save"):
		prev_game_file.open("user://AMBASecretSettings.save", File.WRITE)
		prev_game_file.store_line(to_json({"easter_egg_found":0}))
		prev_game_file.close()
	var dir = Directory.new()
	for i in range(LEVELS_TOTAL+1):
		if prev_game_file.file_exists("user://AMBALevelResults" + str(i) + ".save"):
			dir.remove("user://AMBALevelResults" + str(i) + ".save")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if get_tree().change_scene("res://scenes/levels/News.tscn"):
		pass

func _quit_pressed():
	get_tree().quit()

func _level_select_pressed():
	self.add_child(level_select_res.instance())

func _settings_pressed():
	self.add_child(settings_res.instance())
