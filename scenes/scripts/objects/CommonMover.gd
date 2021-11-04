extends KinematicBody2D
class_name CommonMover

export (bool) var is_trigon = true
export (float) var RotateSpeed = 3.0
export (int) var Radius = 10
export (float) var StretchX = 1.0
export (float) var StretchY = 1.0
export (float) var AngleX = 1.0
export (float) var AngleY = 1.0
var _centre
var _angle = 0

const IDLE_DURATION = 1.0
export (Vector2) var move_to = Vector2(300, 0)
export (float) var speed = 4.0
export (bool) var gravity_up = false
export (float) var follow_smoothness = 0.075
var follow

func _ready():
	if is_trigon:
		_centre = self.position
	else:
		follow = self.position
		_init_tween()

func _init_tween():
	var duration = move_to.length() / float(speed * 64)
	$Tween.interpolate_property(self, "follow", follow, self.position + move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	$Tween.interpolate_property(self, "follow", self.position + move_to, follow, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + 2 * IDLE_DURATION)
	$Tween.start()

func _physics_process(delta):
	if is_trigon:
		_angle += RotateSpeed * delta
		var offset = Vector2(sin(_angle * AngleX) * Radius  * StretchX,
							 cos(_angle * AngleY) * Radius  * StretchY)
		var pos = _centre + offset
		self.position = pos
	else:
		self.position = self.position.linear_interpolate(follow, follow_smoothness)
