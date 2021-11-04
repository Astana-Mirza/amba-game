extends GameLevel

const ENEMIES_TOTAL = 7
const BOTTLES_TOTAL = 3
var lever1 = false
var lever2 = false
var target1 = false
var target2 = false
var target3 = false
var charname = "Ночной Наурыз (по радио)"
var shake_count = 0

func _on_lever1_pressed():
	lever1 = !lever1
	if lever1 and lever2:
		$Button.enable()

func _on_lever2_pressed():
	lever2 = !lever2
	if lever1 and lever2:
		$Button.enable()

func _on_target1_shot():
	$Target1.disable()
	target1 = !target1
	if target1 and target2 and target3:
		$HoloWall1.wall_off()

func _on_target2_shot():
	$Target2.disable()
	target2 = !target2
	if target1 and target2 and target3:
		$HoloWall1.wall_off()

func _on_target3_shot():
	$Target3.disable()
	target3 = !target3
	if target1 and target2 and target3:
		$HoloWall1.wall_off()

func _on_ShakeTimer_timeout():
	shake_count += 1
	$Mirza/Camera2D.offset *= -1
	if shake_count >= 50:
		$Mirza/Camera2D.offset = Vector2.ZERO
		$ShakeTimer.queue_free()

func _on_button_pressed():
	$Button.disable()
	$Pause/Laser.play()
	$BaiterekTop/BaiterekLaser.visible = true
	$Mirza/Camera2D.offset = Vector2(10, 0)
	$ShakeTimer.start()
	$dialogue_node.set_active(true)
	$Finish.position = Vector2(1722, -3313)
