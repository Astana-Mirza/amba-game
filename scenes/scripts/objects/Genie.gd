extends CommonMover

var hp = 5
signal killed
var push_direction = Vector2.ZERO

func _ready():
	push_direction = move_to / max(abs(move_to.x), abs(move_to.y))
	if move_to.x >= 0:
		$Texture.flip_h = true
	if gravity_up:
		$Texture.flip_v = true

func death():
	hp = 10000
	emit_signal("killed")
	$Tween.stop(self)
	$AnimationPlayer.play("genie_death")

func _on_stomp_body_entered(body):
	if body.get_collision_layer() == 4 and hp > 0:
		hp -= body.DAMAGE
		body.queue_free()
	if hp <= 0:
		death()

func _on_tween_completed(object, key):
	$FlipTimer.start(0.4)
	push_direction.x *= -1

func _on_flip_timeout():
	$Texture.flip_h = !$Texture.flip_h
