extends KinematicBody2D

var y_acceleration = 100
var velocity = Vector2(15, -5)
const DAMAGE = 2

func set_shot(var direction_left=true):
	if direction_left:
		velocity.x *= -1

func _physics_process(delta):
	velocity.y += y_acceleration * delta
	if move_and_collide(velocity):
		queue_free()


func _on_screen_exited():
	queue_free()
