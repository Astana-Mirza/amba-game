extends GameLevel

const ENEMIES_TOTAL = 4
const BOTTLES_TOTAL = 2

var easter_egg_near = false
var targets_shot = 0

func _on_lever_pressed():
	for wall in $Walls.get_children():
		wall.wall_toggle()

func _on_target_shot():
	$Target1.disable()
	targets_shot += 1
	if targets_shot == 3:
		targets_shot = 0
		$Walls/HoloWall3.wall_toggle()

func _on_target2_shot():
	$Target2.disable()
	targets_shot += 1
	if targets_shot == 3:
		targets_shot = 0
		$Walls/HoloWall3.wall_toggle()

func _on_target3_shot():
	$Target3.disable()
	targets_shot += 1
	if targets_shot == 3:
		targets_shot = 0
		$Walls/HoloWall3.wall_toggle()

func _input(event):
	if event.is_action_pressed("ui_accept") and easter_egg_near:
		$Mirza.easter_egg_found = 1
		$dialogue_node2.set_active(true)
		$EasterEgg.queue_free()
		var save_file = File.new()
		save_file.open("user://AMBASecretSettings.save", File.WRITE)
		save_file.store_line(to_json({"easter_egg_found":1}))
		save_file.close()

func _on_EasterEgg_body_entered(body):
	if body.is_in_group("player"):
		easter_egg_near = true

func _on_EasterEgg_body_exited(body):
	if body.is_in_group("player"):
		easter_egg_near = false
