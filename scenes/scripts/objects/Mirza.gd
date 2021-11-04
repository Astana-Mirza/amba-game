extends Actor

const MAX_JUMP_COUNT := 2						  # double jump is available
const MAX_HP := 5								  # maximum health

export var slope_slide_treshold := 50.0			  # slope slide treshold 
export var critical_y_down = 1100.0     		  # if out of bounds, assume as
export var critical_y_up = -3500.0				  # fall from the level
export (Array, int) var camera_bounds = [0, -3500, 8500, 720]  # bounds of camera scrolling
												  # (X axis)

var pushed = false
var push_direction = Vector2.ZERO
var floor_normal = Vector2.UP					  # floor normal
var in_dialogue = false							  # dialogue flag
var blink = false								  # red blinking flag
var red_modulate = true							  # red shade flag
var dead = false								  # death flag
var invulnerable_in_boss_flag = false			  # flag that makes the player invulnerable in the last level
var easter_egg_found = 0						  # if found an easter egg
var hp = MAX_HP									  # current health
var bullet_type = "StandardBullet"				  # current type of bullets
var jcount = MAX_JUMP_COUNT						  # how many jumps are available
var anim = "mirza_stand"						  # current animation
onready var player = $AnimationPlayer			  # character's animation player
onready var texture = $Texture					  # character's texture

func _ready():
	var camera = $Camera2D
	camera.limit_left = camera_bounds[0]
	camera.limit_top = camera_bounds[1]
	camera.limit_right = camera_bounds[2]
	camera.limit_bottom = camera_bounds[3]

func set_invulnerable(var flag: bool):
	self.invulnerable_in_boss_flag = flag

# Gets direction normal depending on which buttons were pressed
func get_direction():
	var direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		1.0			# x = sum of the vectors of horizontal direction
	)				# y = gravity direction
	# if a jump button was pressed and any jumps are available
	if Input.is_action_just_pressed("ui_up") and jcount:
		get_parent().get_node("Pause/Effects/Jump").play()
		jcount -= 1								# decrement jump counter
		direction.y = -1.0						# set direction opposite to gravity
	return direction

func death():
	texture.frame = 18
	for life in $HUD/HP.get_children():
		life.visible = false
	if not dead:
		dead = true
		get_node("../DeathScreen").death()

# Calculates character's velocity depending on current velocity,
# direction and maximum speed
func get_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		maxSpeed: Vector2
	):
	var new_velocity = linear_velocity			 # copy current velocity
	new_velocity.x = maxSpeed.x * direction.x	 # set the horizontal part
	# add gravity velocity
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:						 # if jumping
		# set velocity opposite to gravity
		new_velocity.y = maxSpeed.y * direction.y * sign(self.gravity)
	return new_velocity

# Set weapon's bullet type
func select_bullet():
	if Input.is_action_just_pressed("digit1"):	 # if 1 was pressed
		bullet_type = "StandardBullet"			 # select standatd bullets
	elif Input.is_action_just_pressed("digit2"): # if 2 was pressed
		bullet_type = "HeavyBullet"				 # select heavy bullets
	elif Input.is_action_just_pressed("digit3") and easter_egg_found: # if 3 was pressed and easter egg found
		bullet_type = "ComradeBullet"			 # select comrade bullets

# Make a shot (called from the AnimationPlayer)
func mirza_shoot():
	get_parent().get_node("Pause/Effects/Shoot").play()			# play shooting sound effect
	# load bullet node
	var shot = load("res://scenes/env/bullets/" + bullet_type + ".tscn").instance()
	shot.position = self.position				  # set bullet's position
	shot.position.y -= 10 * sign(self.gravity)	  # move it to the gun
	if anim == "mirza_stand_and_shoot":		  	  # if standing and shooting
		shot.position.y -= 30 * sign(self.gravity)# move it closer to the gun
		if texture.flip_h:
			shot.position.x -= 50
		else:
			shot.position.x += 50
	shot.set_shot(texture.flip_h)				  # set direction
	get_tree().get_root().get_child(0).add_child(shot)		  # spawn bullet

# Timer function for changing texture's shade
# when the character is hit. Only gives visual effect (instead of HitTimer)
func _on_blink_timeout():
	if blink:									  # if still blinking
		$BlinkTimer.start(0.2)					  # start the timer again
		if not red_modulate:					  # switch tecture shade
			self.modulate = Color("#ff6464")
		else:
			self.modulate = Color("#ffffff")
		red_modulate = !red_modulate

# Timer for invulnerability after getting hit
func _on_hit_timeout():
	blink = false								  # stop invulnerability
	self.modulate = Color("#ffffff")			  # set normal color

# Timer for changing character's behaviour after being pushed
func _on_push_timeout():
	pushed = false

# Hit detection
func _hit_body_entered(body):
	 # if the character is vulnerable and got hit by an enemy_body
	if body.is_in_group("enemy_body") and not blink and not invulnerable_in_boss_flag:
		jcount = 0								 # only fall
		_velocity.y = 0
		got_hit()								 # call the hit function
	# if the character must be pushed
	if body.is_in_group("pusher"):
		push_direction = body.push_direction	 # change push_direction
		push_direction.y = -1
		pushed = true
		$PushTimer.start()

# Sets invulnerability when the character gets hit
func got_hit():
	get_parent().get_node("Pause/Effects/Hit").play()   # play hit sound effect
	get_node("HUD/HP/life" + str(hp)).visible = false # hide life
	hp -= 1										# lose hp
	$HitDetector.visible = false				# stop getting hit
	blink = true								# setting a flag
	$HitTimer.start(2)							# start the timers
	$BlinkTimer.start(0.2)
	if hp <= 0:									# if there is no hp left
		death()									# loose

# Stop moving and watch the dialogue
func into_dialogue():
	$HitDetector/HitCollision.set_deferred("disabled", true)
	player.play("mirza_stand")
	in_dialogue = true

# Start moving after the dialogue
func out_dialogue():
	$HitDetector/HitCollision.set_deferred("disabled", false)
	in_dialogue = false

# Check if the character is on floor
func ray_is_on_floor():
	for i in $RayCasts.get_children():			 # check the RayCasts first
		if i.is_colliding():
			return true							 # if is on floor, return true
	return is_on_floor()						 # check with the standard function

# Update animation depending on velocity
func update_animation(v):
	if v.x > 0:
		texture.flip_h = false
	elif v.x < 0:
		texture.flip_h = true
	if ray_is_on_floor():
		if v.x:
			anim = "mirza_run"
		else:
			anim = "mirza_stand"
	elif v.y * sign(self.gravity) < 0:
		anim = "mirza_jump"
	else:
		anim = "mirza_fall"
	if Input.is_action_pressed("ui_select"):
		anim += "_and_shoot"
	player.play(anim)

# Reverses the direction of the gravity.
# Does nothing if it is already reversed
func gravity_up():
	$RayCasts.position.y = -118					# move RayCasts to the top
	for c in $RayCasts.get_children():
		c.cast_to.y = -10						   # change their cast direction
	_velocity.y = 0								   # stop jumping
	floor_normal  = Vector2.DOWN				   # reverse floor normal
	self.gravity = -1 * abs(self.gravity)		   # set up the gravity direction
	texture.flip_v = true						   # flip the texture

# Restores the direction of the gravity.
# Does nothing if it is already normal
func gravity_down():
	$RayCasts.position.y = 0					   # move RayCasts to the bottom
	for c in $RayCasts.get_children():
		c.cast_to.y = 1							   # change their cast direction
	_velocity.y = 0								   # stop falling
	floor_normal  = Vector2.UP					   # restore floor normal
	self.gravity = abs(self.gravity)			   # set up the gravity direction
	texture.flip_v = false						   # flip back the texture

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_node("../Pause").pause()
	if in_dialogue:
		_velocity = Vector2(0, gravity)
		_velocity = move_and_slide_with_snap(_velocity, Vector2(0, 32), floor_normal)
		return
	if self.get_position().y > critical_y_down or self.get_position().y < critical_y_up:
		death()
	for i in range(get_slide_count()):
		if get_slide_collision(i).collider.is_in_group("spikes"):
			death()
	select_bullet()
	var direction
	if pushed:
		$AnimationPlayer.play("mirza_fall")
		direction = push_direction
		push_direction.y = 0
	else:
		direction = get_direction()
	_velocity = get_velocity(_velocity, direction, maxSpeed)
	_velocity = move_and_slide_with_snap(_velocity, Vector2(0, 32), floor_normal, slope_slide_treshold)
	if ray_is_on_floor() and direction.y != -1.0:
		jcount = MAX_JUMP_COUNT
	if not pushed:
		update_animation(_velocity)
