extends Area2D

export (bool) var on = false					 # target flag
export (bool) var enable_timer = false			 # timer flag
export (float) var delay = 3					 # timer duration

signal target_shot							 # target's signal

# If the target is shot
func _on_target_body_entered(body):
	if body.is_in_group("bullet") and not $TargetDetector.disabled:
		body.queue_free()
		target_toggle()
		emit_signal("target_shot")

# when the timer stops
func _on_timer_timeout():
	target_toggle()								 # retrieve the initial state
	enable()									 # make the target active again

# Make it inactive
func disable():
	$TargetDetector.set_deferred("disabled", true)
	$TargetTexture.self_modulate = Color("#40ffffff")
	if enable_timer:
		$Timer.start(delay)

# Make it active
func enable():
	$TargetDetector.set_deferred("disabled", false)
	$TargetTexture.self_modulate = Color("#ffffff")

# Turn on the target
func target_on():
	on = true
	$TargetTexture.frame = 1

# Turn off the target
func target_off():
	on = false
	$TargetTexture.frame = 0

# Switches the texture and flag
func target_toggle():
	if on:
		target_off()
	else:
		target_on()

