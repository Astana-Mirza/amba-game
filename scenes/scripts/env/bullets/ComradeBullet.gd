extends KinematicBody2D

var velocity = Vector2(8, 0)
const DAMAGE = 3

func set_shot(var direction_left=true):
	if direction_left:
		velocity.x *= -1

func _physics_process(delta):
	if move_and_collide(velocity):
		queue_free()

func _on_screen_exited():
	queue_free()
