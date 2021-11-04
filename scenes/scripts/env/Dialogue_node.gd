extends Area2D

var can_talk = true
var talking_person = null
var actors = ["actor_1", "actor_2", "actor_3", "actor_4", "actor_mirza",]
var actions = ["play_animation", "set_animation", "play_sprite_animation", "end_dialogue"]
var execute_action = null
var dialogue_start = false
var animation_name : String
var dialogue_line_number = 0

export (Color) var actor_1_text_color
export (Color) var actor_2_text_color
export (Color) var actor_3_text_color
export (Color) var actor_4_text_color

export (NodePath) var actor_1
export (NodePath) var actor_2
export (NodePath) var actor_3
export (NodePath) var actor_4
export (NodePath) var actor_mirza
export (Array, String) var dialogue_lines
export (bool) var active
onready var mirza = get_node(actor_mirza)

signal line_finished
signal dialogue_started
signal dialogue_finished

func _ready():
	if active:
		$CollisionShape2D.set_deferred("disabled", false)
	else:
		$CollisionShape2D.set_deferred("disabled", true)

func _on_dialogue_node_body_entered(body):
	if not body.is_in_group("player"):
		return
	dialogue_start = true
	mirza.into_dialogue()
	emit_signal("dialogue_started")
	$dialogue_placer/text_box.show()
	$dialogue_placer/next.hide()
	$dialogue_placer/speaker_name.show()
	dialogue()

func _input(event):
	if dialogue_start:
		if event.is_action_pressed("ui_select"):
			if can_talk:
				dialogue()
			else:
				$dialogue_placer/text.percent_visible = 100

func dialogue():
	can_talk = false
	var next = true
	while next:
		if dialogue_lines[dialogue_line_number] in actors:
			talking_person = dialogue_lines[dialogue_line_number]
			match talking_person:
				"actor_1":
					talking_person = actor_1
					$dialogue_placer/text.set("custom_colors/font_color", actor_1_text_color)
					$dialogue_placer/speaker_name.set("custom_colors/font_color", actor_1_text_color)
				"actor_2":
					talking_person = actor_2
					$dialogue_placer/text.set("custom_colors/font_color", actor_2_text_color)
					$dialogue_placer/speaker_name.set("custom_colors/font_color", actor_2_text_color)
				"actor_3":
					talking_person = actor_3
					$dialogue_placer/text.set("custom_colors/font_color", actor_3_text_color)
					$dialogue_placer/speaker_name.set("custom_colors/font_color", actor_3_text_color)
				"actor_4":
					talking_person = actor_4
					$dialogue_placer/text.set("custom_colors/font_color", actor_4_text_color)
					$dialogue_placer/speaker_name.set("custom_colors/font_color", actor_4_text_color)
				"actor_mirza":
					talking_person = actor_mirza
					$dialogue_placer/text.set("custom_colors/font_color", Color("#585dd1"))
					$dialogue_placer/speaker_name.set("custom_colors/font_color", Color("#585dd1"))
			$dialogue_placer/speaker_name.text = get_node(talking_person).charname
		elif dialogue_lines[dialogue_line_number] in actions:
				execute_action = dialogue_lines[dialogue_line_number]
				$dialogue_placer/text_timer.stop()
				$dialogue_placer/speaker_name.hide()
				$dialogue_placer/text_box.hide()
				$dialogue_placer/text.hide()
				match execute_action:
					"play_animation":
						var a = get_node(str(talking_person) + "/AnimationPlayer")
						a.play(animation_name)
						yield(a, "animation_finished")
						if talking_person == actor_mirza:
							mirza.into_dialogue()
					"set_animation":
						animation_name = dialogue_lines[dialogue_line_number + 1]
						dialogue_line_number += 1
					"play_sprite_animation":
						animation_name = dialogue_lines[dialogue_line_number + 1]
						dialogue_line_number += 1
						var s = get_node(str(talking_person) + "/Texture")
						s.animation = animation_name
						s.playing = true
					"end_dialogue":
						emit_signal("dialogue_finished")
						mirza.out_dialogue()
						Input.action_release("ui_select")
						queue_free()
						return
				$dialogue_placer/text.show()
		else:
			next = false
			$dialogue_placer/text_box.show()
			$dialogue_placer/next.hide()
			$dialogue_placer/speaker_name.show()
			$dialogue_placer/text.visible_characters = 0
			$dialogue_placer/text.text = dialogue_lines[dialogue_line_number]
			$dialogue_placer/text_timer.start()
			yield(self, "line_finished")
		dialogue_line_number += 1
	can_talk = true

func _on_text_timer_timeout():
	if $dialogue_placer/text.percent_visible != 1:
		$dialogue_placer/text.visible_characters += 1
	else:
		emit_signal("line_finished")
		$dialogue_placer/next.show()

func set_active(var set):
	active = set
	if active:
		$CollisionShape2D.set_deferred("disabled", false)
	else:
		$CollisionShape2D.set_deferred("disabled", true)
