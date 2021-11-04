extends KinematicBody2D
class_name Actor								   # a class for player and some
												   # enemies
var _velocity = Vector2.ZERO					   # velocity vector
export var gravity = 2100.0						   # module of gravity
export var charname = ""						   # name for dialogues
export var maxSpeed = Vector2(300.0, 1000.0)	   # maximum speed values

func set_charname(var name):
	charname = name

func get_charname():
	return charname

func _physics_process(delta):
	_velocity.y += gravity * delta				   # apply graviry
	_velocity.y = move_and_slide(_velocity, Vector2.UP).y # move towards the gravity