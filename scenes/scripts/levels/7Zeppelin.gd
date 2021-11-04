extends GameLevel

const BOTTLES_TOTAL = 3
const ENEMIES_TOTAL = 6
var lever_pressed = false

func _on_button1_pressed():
	$HoloWall4.wall_off()
	$Mirza.gravity_up()
	$Button1.disable()

func _on_button2_pressed():
	$Button2.disable()
	$HoloWall4.wall_on()
	$HoloWall3.wall_off()
	$HoloWall2.wall_off()
	var d = get_node_or_null("dialogue_node2")
	if d:
		d.set_active(true)
	else:
		$Mirza.gravity_down()
		if lever_pressed:
			$HoloWall1.wall_off()

func _on_lever1_pressed():
	lever_pressed = !lever_pressed
	$HoloWall5.wall_toggle()

func _on_lever2_pressed():
	$HoloWallFinish.wall_off()

func _on_dialogue2_finished():
	$Mirza.gravity_down()
	if lever_pressed:
			$HoloWall1.wall_off()
