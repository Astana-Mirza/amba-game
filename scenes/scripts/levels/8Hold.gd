extends GameLevel

const BOTTLES_TOTAL = 3
const ENEMIES_TOTAL = 3

func _on_Boulder_body_entered(body):
	if body.is_in_group("player"):
		body.death()

func _on_dialogue1_finished():
	$HoloWall1.wall_off()

func _on_button1_pressed():
	$Mirza.gravity_up()
	$Button1.disable()

func _on_button2_pressed():
	$HoloWall2.wall_off()
	$Mirza.gravity_down()
	$Button2.disable()

func _on_BoulderSwitcher_body_entered(body):
	if body.is_in_group("boulder"):
		body.gravity_scale *= -1
