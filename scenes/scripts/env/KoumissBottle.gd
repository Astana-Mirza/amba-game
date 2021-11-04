extends Area2D

signal collected

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("collected")
		queue_free()
