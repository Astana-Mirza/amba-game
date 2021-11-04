extends KinematicBody2D

var velocity = Vector2(8, 8)

func set_shot(var direction: Vector2):
	velocity.x *= direction.x
	velocity.y *= direction.y

func _physics_process(delta):
	if move_and_collide(velocity):
		queue_free()
