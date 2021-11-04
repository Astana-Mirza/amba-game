extends GameLevel

const ENEMIES_TOTAL = 6
const BOTTLES_TOTAL = 3

func _on_grav_up1_pressed():					  # if a GravButton was pressed
	$Mirza.gravity_up() 						  # reverse gravity
	$GravButton1.disable()						  # disable button

func _on_grav_down1_pressed():					  # if a GravButton was pressed
	$Mirza.gravity_down() 						  # reverse gravity again
	$GravButton2.disable()						  # disable button

func _on_grav_up2_pressed():					  # if a GravButton was pressed
	$Mirza.gravity_up() 						  # reverse gravity
	$GravButton3.disable()						  # disable button

func _on_grav_down2_pressed():					  # if a GravButton was pressed
	$Mirza.gravity_down() 						  # reverse gravity again
	$GravButton4.disable()						  # disable button

func _on_grav_up3_pressed():					  # if a GravButton was pressed
	$Mirza.gravity_up() 						  # reverse gravity
	$GravButton5.disable()						  # disable button

func _on_grav_down3_pressed():					  # if a GravButton was pressed
	$Mirza.gravity_down() 						  # reverse gravity again
	$GravButton6.disable()						  # disable button
