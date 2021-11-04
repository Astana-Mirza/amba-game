extends GameLevel

const SPAWN_COUNT = 60
var enemies_spawned = 0
var started = false
var dwarf_res = preload("res://scenes/enemies/ToothDwarf.tscn")
var default_cursor = preload("res://scenes/textures/misc/default_cursor.png")
var aim_cursor = preload("res://scenes/textures/misc/aim_cursor.png")
var bullet_res = preload("res://scenes/env/bullets/NazarBullet.tscn")
onready var gun = $NazarGun/TextureMain
var ready_to_shoot = true
var charname = "Голосовой помощник капитана НазарБоБо"

func start_caries_invasion():
	started = true
	Input.set_custom_mouse_cursor(aim_cursor)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Mirza.into_dialogue()
	$Mirza.position = Vector2(100, -400)
	$Mirza/Texture.visible = false
	$NazarGun/TextureBottom.frame = 1
	$SpawnTimer.start(rand_range(0.5, 0.8))

func finish_caries_invasion():
	started = false
	$Enemies.queue_free()
	Input.set_custom_mouse_cursor(default_cursor)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$SpawnTimer.stop()
	$dialogue_node3.set_active(true)

func spawn_enemy():
	var x = rand_range(0, PI)
	var spawn_point = Vector2(900*cos(x), -900*sin(x))
	var dwarf = dwarf_res.instance()
	dwarf.connect("killed", self, "_on_enemy_killed")
	dwarf.position = spawn_point
	if dwarf.position.x < 0:
		dwarf.get_node("Texture").flip_h = true
	dwarf.move_to = -1 * spawn_point
	$Enemies.add_child(dwarf)					# spawn enemy
	enemies_spawned += 1

func _on_unpaused():
	if started:
		Input.set_custom_mouse_cursor(aim_cursor)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_enemy_killed():
	$Pause/Effects/Enemy.play()
	enemies_killed += 1
	if enemies_killed == enemies_spawned and enemies_spawned >= SPAWN_COUNT:
		finish_caries_invasion()

func _on_NazarGun_body_entered(body):
	if body.is_in_group("enemy_body"):
		body.death()
		$Mirza.got_hit()
	elif body.is_in_group("player") and not started:
		start_caries_invasion()

func _on_SpawnTimer_timeout():
	if enemies_spawned < SPAWN_COUNT:
		spawn_enemy()
		$SpawnTimer.start(rand_range(0.5, 0.8))

func _on_ShotTimer_timeout():
	ready_to_shoot = true

func _on_dialogue3_finished():
	$Pause/Effects/Explosion.play()
	$Explosion/AnimationPlayer.play("explosion")
	$NazarGun/CollisionShape2D.queue_free()
	started = false
	$NazarGun/TextureBottom.frame = 0
	$Mirza.position = Vector2(0, -100)
	$Mirza._velocity = Vector2(0, -3500)
	$Mirza/Texture.visible = true


func _physics_process(delta):
	if not started:
		return
	var cursor_pos = get_viewport().get_mouse_position()
	var angle = atan2(500-cursor_pos.y, cursor_pos.x-640)
	if angle < -PI/2:
		angle = PI
	elif angle < 0:
		angle = 0
	if angle > PI/2:
		gun.frame = 1
		$NazarGun/TextureBottom.frame = 2
	else:
		gun.frame = 0
		$NazarGun/TextureBottom.frame = 1
	gun.rotation_degrees = -rad2deg(angle)
	if (Input.is_action_just_pressed("ui_select") or Input.is_mouse_button_pressed(BUTTON_LEFT)) and ready_to_shoot:
		$Pause/Effects/Shoot.play()				  # play shooting sound effect
		var bullet = bullet_res.instance()
		bullet.set_shot(angle)
		self.add_child(bullet)				  # spawn enemy
		ready_to_shoot = false
		$NazarGun/ShotTimer.start()
