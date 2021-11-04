extends Area2D

var character_near = false
signal lever_pressed

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and character_near:
		$LeverTexture.frame = ($LeverTexture.frame + 1) % 2
		Input.action_release("ui_accept")
		emit_signal("lever_pressed")

func _on_lever_body_entered(body):
	if body.is_in_group("player"):
		Input.action_release("ui_accept")
		character_near = true

func _on_lever_body_exited(body):
	if body.is_in_group("player"):
		character_near = false
