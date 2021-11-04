extends KinematicBody2D

export (int) var y_bound = 1000
var _velocity = Vector2(0, 17)

func _on_StompDetector_body_entered(body):
	if body.is_in_group("player"):
		if not body.blink:
			body.got_hit()

func _physics_process(delta):
	move_and_collide(_velocity)
	if self.position.y > y_bound:
		queue_free()
