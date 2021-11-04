extends KinematicBody2D

var velocity = Vector2(-15, 0)

func set_shot(var reverse=false):
	if reverse:
		$Texture.flip_h = true
		velocity.x *= -1

func _physics_process(delta):
	if move_and_collide(velocity):
		queue_free()