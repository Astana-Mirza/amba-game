extends GameLevel

const ENEMIES_TOTAL = 1
const BOTTLES_TOTAL = 0

func _on_lever_pressed():
	$HoloWall.wall_toggle()
