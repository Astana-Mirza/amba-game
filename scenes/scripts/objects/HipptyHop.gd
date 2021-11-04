extends StaticBody2D

var shot_res = preload("res://scenes/env/bullets/ElectroBall.tscn")
var hp = 4
signal killed

func shoot():
	var v1 = get_node("../Mirza").position
	var v2 = self.position + Vector2(0, -64)
	var x = v1-v2
	var shot = shot_res.instance()
	shot.position = v2
	shot.set_shot(x/max(abs(x.x), abs(x.y)))
	get_node("..").add_child(shot)

func death():
	hp = 10000
	emit_signal("killed")
	$AnimationPlayer.play("hippty_hop_death")

func _on_stomp_body_entered(body):
	if body.get_collision_layer() == 4 and hp > 0:
		hp -= body.DAMAGE
		body.queue_free()
	if hp <= 0:
		death()
