extends GameLevel

var current_question = 1
var time_travel = false

func _on_button1_pressed():
	$Button1.disable()
	$Button2.disable()
	$Button3.disable()
	$Button2.button_toggle()
	$Button3.button_toggle()
	if current_question == 4:
		next_dialogue()
	else:
		explosion()

func _on_button2_pressed():
	$Button1.disable()
	$Button2.disable()
	$Button3.disable()
	$Button1.button_toggle()
	$Button3.button_toggle()
	if current_question == 1:
		next_dialogue()
	elif current_question == 5:
		next_dialogue()
		win(time_travel)
	else:
		explosion()

func _on_button3_pressed():
	$Button1.disable()
	$Button2.disable()
	$Button3.disable()
	$Button1.button_toggle()
	$Button2.button_toggle()
	if current_question == 2 or current_question == 3:
		next_dialogue()
	else:
		explosion()

func explosion():
	$Pause/Effects/Explosion.play()
	for i in $Explosions.get_children():
		i.get_node("AnimationPlayer").play("explosion")

func _on_explosion_animation_finished(anim_name):
	if anim_name == "explosion":
		$Mirza.death()

func next_dialogue():
	var prev = get_node_or_null("dialogue_node" + str(current_question))
	if prev:
		prev.queue_free()
		time_travel = true
	current_question += 1
	get_node("dialogue_node" + str(current_question)).set_active(true)
	$Felix/Texture.animation = "happy"

func win(var time_travel):
	$Cannons.queue_free()
	$Button1.queue_free()
	$Button2.queue_free()
	$Button3.queue_free()
	$HoloWall.wall_off()
	if time_travel:
		get_node("dialogue_node6").set_active(false)
		get_node("dialogue_node6_alt").set_active(true)
		get_node("dialogue_node_end").set_active(false)
	$Felix.position = Vector2(1535, 519)
