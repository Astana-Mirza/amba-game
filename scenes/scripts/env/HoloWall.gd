extends StaticBody2D

export var on = true								  # wall flag, initial state

func _ready():
	if not on:
		wall_off()

# Turn on the barrier
func wall_on():
	on = true
	$WallCollision.set_deferred("disabled", false)
	$WallBricks.visible = true

# Turn off the barrier
func wall_off():
	on = false
	$WallCollision.set_deferred("disabled", true)
	$WallBricks.visible = false

# Switch the barrier
func wall_toggle():
	if on:
		wall_off()
	else:
		wall_on()