extends GameLevel

func _on_dialogue1_finished():
	$NightNauryz.start_battle()

func _on_dialogue2_started():
	$Mirza/Texture.flip_h = false

func _on_dialogue2_finished():
	$Finish.position = Vector2(1048, -694)

func end_game():
	$Mirza.set_invulnerable(true)
	$dialogue_node2.set_active(true)
