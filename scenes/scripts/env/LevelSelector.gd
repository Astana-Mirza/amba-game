extends Control

const LEVEL_COUNT = 12
const MAX_KOIMUSS = 24
const MAX_ENEMIES = 48
var total_koumiss = 0
var total_enemies = 0
var last_level = -1

func _ready():
	read_levels()
	activate_buttons()

func _on_Level0_pressed():
	if last_level < 0:
		if get_tree().change_scene("res://scenes/levels/News.tscn"):
			pass
		return
	if get_tree().change_scene("res://scenes/levels/Tutorial.tscn"):
		pass

func _on_Level1_pressed():
	if get_tree().change_scene("res://scenes/levels/1Streets_of_Astana.tscn"):
		pass

func _on_Level2_pressed():
	if get_tree().change_scene("res://scenes/levels/2Old_Town.tscn"):
		pass

func _on_Level3_pressed():
	if get_tree().change_scene("res://scenes/levels/3Traps.tscn"):
		pass

func _on_Level4_pressed():
	if get_tree().change_scene("res://scenes/levels/4Collector.tscn"):
		pass

func _on_Level5_pressed():
	if get_tree().change_scene("res://scenes/levels/5Seals.tscn"):
		pass

func _on_Level6_pressed():
	if get_tree().change_scene("res://scenes/levels/6Smell.tscn"):
		pass

func _on_Level7_pressed():
	if get_tree().change_scene("res://scenes/levels/7Zeppelin.tscn"):
		pass

func _on_Level8_pressed():
	if get_tree().change_scene("res://scenes/levels/8Hold.tscn"):
		pass

func _on_Level9_pressed():
	if get_tree().change_scene("res://scenes/levels/9Duel.tscn"):
		pass

func _on_Level10_pressed():
	if get_tree().change_scene("res://scenes/levels/10Baiterek1.tscn"):
		pass

func _on_Level11_pressed():
	if get_tree().change_scene("res://scenes/levels/11Baiterek2.tscn"):
		pass

func _on_Level12_pressed():
	if get_tree().change_scene("res://scenes/levels/12The_End.tscn"):
		pass

func _on_Bonus_pressed():
	if get_tree().change_scene("res://scenes/levels/BonusLevel.tscn"):
		pass

func _on_close_pressed():
	queue_free()

func read_levels():
	var save_file = File.new()
	for i in range(LEVEL_COUNT+1):
		var path = "user://AMBALevelResults" + str(i) + ".save"
		if save_file.file_exists(path):
			save_file.open(path, File.READ)
			var dict = parse_json(save_file.get_line())
			if int(dict["won"]) == 1:
				last_level += 1
				if dict.has("enemies_killed"):
					total_enemies += int(dict["enemies_killed"])
				if dict.has("koumiss_collected"):
					total_koumiss += int(dict["koumiss_collected"])
				save_file.close()
			else:
				save_file.close()
				return
			save_file.close()
		else:
			return
	if total_enemies >= MAX_ENEMIES and total_koumiss >= MAX_KOIMUSS:
		$Panel/Level13.visible = true

func activate_buttons():
	for i in range(1, last_level+2):
		var button = get_node_or_null("Panel/Level" + str(i))
		if button:
			button.disabled = false
	for i in range(last_level+2, LEVEL_COUNT+1):
		var button = get_node_or_null("Panel/Level" + str(i))
		button.set_text("Закрыто")
