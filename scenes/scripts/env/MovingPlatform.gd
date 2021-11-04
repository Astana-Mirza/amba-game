extends KinematicBody2D

export var idle_duration = 1.0
export var flip = false
export var one_way_collision = true
export (Array, Vector2) var move_points
export var speed = 4.0

var follow
var start
var vector_num = 0

func _ready():
	if flip:
		$PlatformTexture.flip_v = true
	if not one_way_collision:
		$PlatformCollision.one_way_collision = false
	start = self.position
	_init_tween()

func _init_tween():
	var duration
	follow = self.position
	for move_to in move_points:
		duration = move_to.length() / float(speed * 64)
		$Tween.interpolate_property(self, "follow", follow,\
		 self.position + move_to, duration, Tween.TRANS_LINEAR, \
		 Tween.EASE_IN_OUT, duration * vector_num + idle_duration * (vector_num + 1))
		vector_num += 1
		follow = self.position + move_to
	duration = (follow - start).length() / float(speed * 64)
	$Tween.interpolate_property(self, "follow", follow, start, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration * vector_num + idle_duration * (vector_num + 1))
	$Tween.start()

func _physics_process(delta):
	self.position = self.position.linear_interpolate(follow, 0.075)
