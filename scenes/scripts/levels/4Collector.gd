extends GameLevel

const ENEMIES_TOTAL = 9
const BOTTLES_TOTAL = 4

var lever1 = false
var lever2 = false
var lever3 = false

func _on_target_shot():
	$HoloWall2.wall_toggle()
	$HoloWall3.wall_toggle()
	$HoloWall5.wall_toggle()

func _on_lever1_pressed():
	lever1 = !lever1
	if lever1 and lever2 and lever3:
		$HoloWall1.wall_off()

func _on_lever2_pressed():
	lever2 = !lever2
	if lever1 and lever2 and lever3:
		$HoloWall1.wall_off()

func _on_lever3_pressed():
	lever3 = !lever3
	if lever1 and lever2 and lever3:
		$HoloWall1.wall_off()
