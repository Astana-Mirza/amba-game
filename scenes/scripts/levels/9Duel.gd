extends GameLevel

var boss_hp = 15
var battle_started = false
var gun_num

func swap_shield():
	$Zeppelin/zeppelin_field1.visible = true
	$Zeppelin/zeppelin_field2.visible = true
	$Zeppelin/zeppelin_field3.visible = true
	gun_num = str(int(rand_range(1, 4)))
	get_node("Zeppelin/zeppelin_field" + gun_num).visible = false
	$Zeppelin.frame = int(gun_num)
	$Zeppelin/ShotTimer.start()
	$Zeppelin/ShieldTimer.start()

func finish_battle():
	$Button1.queue_free()
	$Button2.queue_free()
	$Button3.queue_free()
	$Zeppelin/zeppelin_field1.visible = false
	$Zeppelin/zeppelin_field2.visible = false
	$Zeppelin/zeppelin_field3.visible = false
	$AnimationPlayer.play("zeppelin_death")
	battle_started = false
	$dialogue_node2.set_active(true)

func _on_button1_pressed():
	$Button1.disable()
	$Button2.button_toggle()
	$Button3.button_toggle()
	$Button2.disable()
	$Button3.disable()
	if not $Zeppelin/zeppelin_field1.visible and not ($Shield1.visible or $Shield2.visible or $Shield3.visible):
		$Pause/Beam.play()
		$LaserGuns/LaserTimer.start()
		$LaserGuns/laser1.visible = true
		boss_hp -= 1
		if boss_hp <= 0:
			finish_battle()

func _on_button2_pressed():
	$Button1.button_toggle()
	$Button3.button_toggle()
	$Button1.disable()
	$Button2.disable()
	$Button3.disable()
	if not $Zeppelin/zeppelin_field2.visible and not ($Shield1.visible or $Shield2.visible or $Shield3.visible):
		$Pause/Beam.play()
		$LaserGuns/LaserTimer.start()
		$LaserGuns/laser2.visible = true
		boss_hp -= 1
		if boss_hp <= 0:
			finish_battle()

func _on_button3_pressed():
	$Button1.button_toggle()
	$Button2.button_toggle()
	$Button1.disable()
	$Button2.disable()
	$Button3.disable()
	if not $Zeppelin/zeppelin_field3.visible and not ($Shield1.visible or $Shield2.visible or $Shield3.visible):
		$Pause/Beam.play()
		$LaserGuns/LaserTimer.start()
		$LaserGuns/laser3.visible = true
		boss_hp -= 1
		if boss_hp <= 0:
			finish_battle() 

func _on_LaserTimer_timeout():
	$LaserGuns/laser1.visible = false
	$LaserGuns/laser2.visible = false
	$LaserGuns/laser3.visible = false

func _on_ShieldTimer_timeout():
	if battle_started:
		swap_shield()

func _on_ShotTimer_timeout():
	get_node("Explosion" + gun_num + "/AnimationPlayer").play("explosion")
	get_node("Explosion" + gun_num).visible = true
	$Pause/Effects/Explosion.play()
	$Zeppelin.frame = 0

func _on_lever1_pressed():
	$Shield1.visible = !$Shield1.visible

func _on_lever2_pressed():
	$Shield2.visible = !$Shield2.visible

func _on_lever3_pressed():
	$Shield3.visible = !$Shield3.visible

func _on_dialogue1_finished():
	randomize()
	battle_started = true
	swap_shield()

func _on_dialogue2_finished():
	$HoloWall.wall_off()

func _on_Explosion1_finished(anim_name):
	if anim_name == "explosion":
		if not get_node("Shield" + gun_num).visible:
			$Mirza.got_hit()
		$Explosion1.visible = false

func _on_Explosion2_finished(anim_name):
	if anim_name == "explosion":
		if not get_node("Shield" + gun_num).visible:
			$Mirza.got_hit()
		$Explosion2.visible = false

func _on_Explosion3_finished(anim_name):
	if anim_name == "explosion":
		if not get_node("Shield" + gun_num).visible:
			$Mirza.got_hit()
		$Explosion3.visible = false
