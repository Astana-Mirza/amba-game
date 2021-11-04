extends GameSaveNode

var music_pos = 0.0
var was_turned_off = false

func _ready():
	read_game_parameters()
	apply_settings()

func _on_screen_res_pressed():
	$PanelContainer/Panel/VBoxContainer/ScreenRes/Popup.rect_global_position = $PanelContainer/Panel/VBoxContainer/ScreenRes.rect_global_position + Vector2(0, 25)
	$PanelContainer/Panel/VBoxContainer/ScreenRes/Popup.popup()

func _on_popup_index_pressed(index):
	match index:
		0:
			pass
		1:
			pass
		2:
			#get_tree().get_root().size = Vector2(800, 600)
			pass

func _on_close_pressed():
	save_game_parameters()
	queue_free()

func _on_MusicSound_value_changed(value):
	music_vol = value
	if value == -50:
		music_pos = get_parent().get_node("Music").get_playback_position()
		get_parent().get_node("Music").stop()
	else:
		if music_pos != 0.0:
			get_parent().get_node("Music").play(music_pos)
			music_pos = 0.0
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
		if was_turned_off:
			get_parent().get_node("Music").play()
			was_turned_off = false

func apply_settings():
	if music_vol == -50:
		was_turned_off = true
	$PanelContainer/Panel/MusicSound.value = music_vol
	$PanelContainer/Panel/EffectSound.value = effects_vol

func _on_EffectSound_value_changed(value):
	effects_vol = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), value)
	if value <= -50:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Effects"), false)
