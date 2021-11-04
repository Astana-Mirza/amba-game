extends GameLevel

const ENEMIES_TOTAL = 10
const BOTTLES_TOTAL = 3

func _on_target1_shot():
	$Target.disable()
	$Pause/Effects/Explosion.play()
	$Explosion/AnimationPlayer.play("explosion")

func _on_explosion_finished(anim_name):
	$Explosion.visible = false
	for i in $Stalkers.get_children():
		i.death()
