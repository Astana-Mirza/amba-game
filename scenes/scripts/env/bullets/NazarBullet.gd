extends KinematicBody2D

var velocity = Vector2(0, 0)
const MAX_SPEED = 10
const DAMAGE = 5

func set_shot(var angle):
	$Texture.rotation_degrees = 90-rad2deg(angle)
	velocity = MAX_SPEED * Vector2(cos(angle), -sin(angle))

func _physics_process(delta):
	if move_and_collide(velocity):
		queue_free()

func _on_screen_exited():
	queue_free()
