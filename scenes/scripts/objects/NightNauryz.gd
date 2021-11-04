extends Actor

const MAX_DST = 800
const MIN_DST = 200
var shot_res = preload("res://scenes/env/bullets/NightNauryzKnife.tscn")
var meteor_res = preload("res://scenes/env/Meteor.tscn")
var is_busy = false
var battle_started = false
var extra_action = false
var hp = 50

func start_battle():
	randomize()
	battle_started = true
	$ExtraTimer.start()

func finish_battle():
	battle_started = false
	get_node("..").end_game()
	$ActionTimer.stop()
	$ExtraTimer.stop()
	self.position = Vector2(1117, -320)
	$SwordDetector.queue_free()
	$Texture.flip_h = false
	$AnimationPlayer.play("nn_defeated")
	self.remove_from_group("enemy_body")

func nn_meteor():
	$AnimationPlayer.play("nn_meteor")
	var meteor = meteor_res.instance()
	meteor.position = Vector2(get_node("../Mirza").position.x, -1500)  # set meteor's position
	meteor.position.y -= 15
	$Meteor.play()
	get_tree().get_root().get_node("12The_End").add_child(meteor)  # spawn meteor

func nn_sword():
	$AnimationPlayer.play("nn_sword")
	$Sword.play()

func nn_teleport(var mirza_pos):
	$AnimationPlayer.play("nn_teleport")
	$Sword.play()
	if mirza_pos.x > self.position.x: 
		self.position = mirza_pos - Vector2(100, 0)
	else:
		self.position = mirza_pos + Vector2(100, 0)

func nn_shoot():
	$AnimationPlayer.play("nn_shoot")
	var shot = shot_res.instance()
	shot.position = self.position				  # set bullet's position
	shot.position.y -= 15
	shot.set_shot($Texture.flip_h)				  # set direction
	$Knife.play()
	get_tree().get_root().get_child(0).add_child(shot)	  # spawn bullet

func _on_animation_finished(anim_name):
	if anim_name == "nn_static" or anim_name == "nn_defeated":
		return
	elif anim_name == "nn_sword":
		$SwordDetector/SwordCollision.scale = Vector2.ZERO
		if $Texture.flip_h:
			self.position.x += 50
		else:
			self.position.x -= 50
	$AnimationPlayer.play("nn_static")
	is_busy = false

func _on_stomp_body_entered(body):
	if body.get_collision_layer() == 4:
		if hp > 0:
			hp -= body.DAMAGE
		body.queue_free()
	if hp <= 0 and battle_started:
		finish_battle()

func _on_sword_body_entered(body):
	if body.is_in_group("player"):
		if not body.blink:
			body.got_hit()

func _on_extra_timeout():
	extra_action = true

func _on_ActionTimer_timeout():
	var mirza_pos = get_node("../Mirza").position
	var dst = sqrt(pow((mirza_pos.x - self.position.x), 2) + pow((mirza_pos.y - self.position.y), 2))
	if dst > MAX_DST:
		nn_teleport(mirza_pos)
	elif dst < MIN_DST:
		nn_sword()
	else:
		nn_shoot()

func _process(delta):
	if not battle_started:
		return
	if get_node("../Mirza").position.x > self.position.x:
		$Texture.flip_h = true
		$NightNauryzCollision.position = Vector2(-27, 15)
		$StompDetector/StompBody.position = Vector2(-27, 15)
	else:
		$Texture.flip_h = false
		$NightNauryzCollision.position = Vector2(27, 15)
		$StompDetector/StompBody.position = Vector2(27, 15)
	if extra_action:
		extra_action = false
		is_busy = true
		if randi()%2:
			nn_teleport(get_node("../Mirza").position)
		else:
			nn_meteor()
		$ExtraTimer.start()
	if not is_busy:
		is_busy = true
		$ActionTimer.start(rand_range(0.2, 1.4))
