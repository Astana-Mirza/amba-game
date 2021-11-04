extends CommonMover

var hp = 3
signal killed

func death():
	hp = 10000
	emit_signal("killed")
	RotateSpeed = 0
	$AnimationPlayer.play("stalker_death")

func _on_stomp_body_entered(body):
	if body.get_collision_layer() == 4 and hp > 0:
		hp -= body.DAMAGE
		body.queue_free()
	if hp <= 0:
		death()
