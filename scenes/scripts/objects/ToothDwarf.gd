extends CommonMover

var hp = 4
signal killed

func _ready():
	if not is_trigon:
		if move_to.x < 0:
				$Texture.flip_h = false

func death():
	hp = 10000
	emit_signal("killed")
	RotateSpeed = 0
	$Tween.stop(self)
	$AnimationPlayer.play("tooth_dwarf_death")

func _on_stomp_body_entered(body):
	if body.get_collision_layer() == 4 and hp > 0:
		hp -= body.DAMAGE
		body.queue_free()
	if hp <= 0:
		death()

func _on_tween_completed(object, key):
	$FlipTimer.start(0.4)

func _on_flip_timeout():
	if move_to.x != 0:
		$Texture.flip_h = !$Texture.flip_h
