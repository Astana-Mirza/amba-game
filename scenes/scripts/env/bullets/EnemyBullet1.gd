extends KinematicBody2D

var velocity = Vector2.ZERO

# Default direction - up for vertical, right for horizontal
func set_shot(var pos: Vector2, var vertial=false, var reverse=false):
	self.position = pos
	self.rotation_degrees = 90
	if vertial:
		velocity = Vector2(0, -10)
	else:
		velocity = Vector2(10, 0)
	if reverse:
		self.position.x -= 90
		velocity *= -1

func _physics_process(delta):
	if move_and_collide(velocity):
		queue_free()
