extends Area2D

export (bool) var on = false					 # button flag
export (bool) var enable_timer = false			 # timer flag
export (float) var delay = 3					 # timer duration
export (bool) var enabled = true				 # available flag

var character_near = false						 # shows if player is near
signal button_pressed							 # button's signal

func _ready():
	if on:
		button_on()
	else:
		button_off()
	if enabled:
		enable()
	else:
		disable()

# If player is near
func _on_button_body_entered(body):
	if body.is_in_group("player"):
		character_near = true

# If player moved too far
func _on_button_body_exited(body):
	if body.is_in_group("player"):
		character_near = false

# when the timer stops
func _on_timer_timeout():
	button_toggle()								 # retrieve the initial state
	enable()									 # make the button pressable again

# Make it unpressable
func disable():
	$ButtonDetector.disabled = true
	$ButtonTexture.self_modulate = Color("#40ffffff")
	if enable_timer:
		$Timer.start(delay)

# Make it pressable
func enable():
	$ButtonDetector.disabled = false
	$ButtonTexture.self_modulate = Color("#ffffff")

# Turn on the button
func button_on():
	on = true
	$ButtonTexture.frame = 1

# Turn off the button
func button_off():
	on = false
	$ButtonTexture.frame = 0

# Switches the texture and flag
func button_toggle():
	if on:
		button_off()
	else:
		button_on()

func _process(delta):
	if Input.is_action_pressed("ui_accept") and character_near:
		button_toggle()
		emit_signal("button_pressed")
