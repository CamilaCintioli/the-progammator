extends KinematicBody2D

onready var collision = $CollisionShape2D
onready var tween = $Tween

const MARGIN_PLATFORM = 150
const IDLE_DURATION = 0.55
export var move_to = Vector2.RIGHT
export var speed = 2850.0

func _ready():
	move_to = Vector2(global_position.x + MARGIN_PLATFORM, global_position.y)
	_init_tween()

func _init_tween():
	var duration = global_position.length() / float(speed * IDLE_DURATION)
	tween.interpolate_property(self, "position", global_position, move_to, duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "position", move_to, global_position, duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, (duration + IDLE_DURATION * 2))
	tween.start()

func _on_BodyArea_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		body.enemy_hit()
		
func _remove():
	get_parent().remove_child(self)
	queue_free()

func _on_HeadArea_body_entered(body):
	if body.is_in_group("dron"):
		body.enemy_hit()
	if body.is_in_group("programmer"):
		get_parent().play_robot_killed_sound()
		call_deferred("_remove")
