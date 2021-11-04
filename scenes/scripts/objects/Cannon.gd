extends StaticBody2D

export var shooting = true
export var vertical = false
export var flip_v = false
export var flip_h = false

var shot_pos = Vector2(33, 3)
onready var texture = $CannonTexture
onready var collision = $CannonCollision

func _ready():
	if flip_v:
		texture.flip_v = true
	if flip_h:
		shot_pos.y * -1 if vertical else shot_pos.y * -1
		texture.flip_h = false
		collision.position = Vector2(10, 0)
	else:
		texture.flip_h = true
		collision.position = Vector2(-10, 0)
	if vertical:
		self.rotation_degrees = -90
		shot_pos = Vector2(30, 0)

func set_shooting(var flag):
	shooting = flag

func get_shooting():
	return shooting

func shoot():
	if !shooting:
		return
	var shot = load("res://scenes/env/bullets/EnemyBullet1.tscn").instance()
	shot.set_shot(shot_pos, vertical, flip_h)	  # set direction
	self.add_child(shot)		 								  # spawn bullet
