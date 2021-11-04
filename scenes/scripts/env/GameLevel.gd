extends GameSaveNode
class_name GameLevel

var bottles_collected = 0			# number of koumiss bottles collected
var enemies_killed = 0				# numver of enemies killed

func _ready():
	apply_secret_parameters()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) # hide cursor

# called every time when an enemy is killed
func _on_enemy_killed():
	$Pause/Effects/Enemy.play()
	enemies_killed += 1						# increment the counter

# called every time when koumiss is collected
func _on_koumiss_collected():
	$Pause/Effects/Koumiss.play()
	bottles_collected += 1					# increment the counter
