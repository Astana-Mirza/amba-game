extends GameLevel

const ENEMIES_TOTAL = 2
const BOTTLES_TOTAL = 3

var btn_num = 0

func _on_seal1_timer_timeout():
	$Seal1.position = Vector2(-494, 363)
	var open = true
	for i in range(1, 5):
		if not get_node("Seal1/Button" + str(i)).on:
			open = false
	if $Seal1/Button5.on:
		open = false
	for i in range(6, 10):
		if not get_node("Seal1/Button" + str(i)).on:
			open = false
	if open:
		$HoloWall1.wall_off()

func check_seal2():
	btn_num += 1
	if btn_num == 1:
		$Seal2/Timer.start(5.5)
		$Seal2/HoloWall1.wall_on()
		$Seal2/HoloWall2.wall_on()
	elif btn_num == 5:
		$HoloWall2.wall_off()

func _on_Button1_pressed():
	$Seal1.position = Vector2(1000, 0)
	$Seal1/Button1.button_toggle()
	$Seal1/Button1.disable()
	$Seal1/Button2.disable()
	$Seal1/Button4.disable()
	$Seal1/Timer.start(0.2)

func _on_Button2_pressed():
	$Seal1.position = Vector2(1000, 0)
	$Seal1/Button2.button_toggle()
	$Seal1/Button1.disable()
	$Seal1/Button2.disable()
	$Seal1/Button3.disable()
	$Seal1/Button5.disable()
	$Seal1/Timer.start(0.2)

func _on_Button3_pressed():
	$Seal1.position = Vector2(1000, 0)
	$Seal1/Button3.button_toggle()
	$Seal1/Button2.disable()
	$Seal1/Button3.disable()
	$Seal1/Button6.disable()
	$Seal1/Timer.start(0.2)

func _on_Button4_pressed():
	$Seal1.position = Vector2(1000, 0)
	$Seal1/Button4.button_toggle()
	$Seal1/Button1.disable()
	$Seal1/Button4.disable()
	$Seal1/Button5.disable()
	$Seal1/Button7.disable()
	$Seal1/Timer.start(0.2)

func _on_Button5_pressed():
	$Seal1.position = Vector2(1000, 0)
	$Seal1/Button5.button_toggle()
	$Seal1/Button2.disable()
	$Seal1/Button4.disable()
	$Seal1/Button5.disable()
	$Seal1/Button6.disable()
	$Seal1/Button8.disable()
	$Seal1/Timer.start(0.2)

func _on_Button6_pressed():
	$Seal1.position = Vector2(1000, 0)
	$Seal1/Button6.button_toggle()
	$Seal1/Button3.disable()
	$Seal1/Button5.disable()
	$Seal1/Button6.disable()
	$Seal1/Button9.disable()
	$Seal1/Timer.start(0.2)

func _on_Button7_pressed():
	$Seal1.position = Vector2(1000, 0)
	$Seal1/Button7.button_toggle()
	$Seal1/Button4.disable()
	$Seal1/Button7.disable()
	$Seal1/Button8.disable()
	$Seal1/Timer.start(0.2)

func _on_Button8_pressed():
	$Seal1.position = Vector2(1000, 0)
	$Seal1/Button8.button_toggle()
	$Seal1/Button5.disable()
	$Seal1/Button7.disable()
	$Seal1/Button8.disable()
	$Seal1/Button9.disable()
	$Seal1/Timer.start(0.2)

func _on_Button9_pressed():
	$Seal1.position = Vector2(1000, 0)
	$Seal1/Button9.button_toggle()
	$Seal1/Button6.disable()
	$Seal1/Button8.disable()
	$Seal1/Button9.disable()
	$Seal1/Timer.start(0.2)

func _on_seal2_timer_timeout():
	btn_num = 0
	$Seal2/HoloWall1.wall_off()
	$Seal2/HoloWall2.wall_off()
	$Seal2/Button1.button_off()
	$Seal2/Button2.button_off()
	$Seal2/Button3.button_off()
	$Seal2/Button4.button_off()
	$Seal2/Button5.button_off()
	$Seal2/Button1.enable()
	$Seal2/Button2.enable()
	$Seal2/Button3.enable()
	$Seal2/Button4.enable()
	$Seal2/Button5.enable()

func _on_seal2_button1_pressed():
	$Seal2/Button1.disable()
	check_seal2()

func _on_seal2_button2_pressed():
	$Seal2/Button2.disable()
	check_seal2()

func _on_seal2_button3_pressed():
	$Seal2/Button3.disable()
	check_seal2()

func _on_seal2_button4_pressed():
	$Seal2/Button4.disable()
	check_seal2()

func _on_seal2_button5_pressed():
	$Seal2/Button5.disable()
	check_seal2()
