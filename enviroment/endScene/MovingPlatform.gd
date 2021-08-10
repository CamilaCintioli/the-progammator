extends KinematicBody2D

onready var collision = $CollisionPolygon2D
onready var tween = $Tween

const MARGIN_PLATFORM = 850
const IDLE_DURATION = 1.25
export var move_to = Vector2.RIGHT
export var speed = 800.0

func _ready():
	move_to = Vector2(global_position.x + MARGIN_PLATFORM, global_position.y)
	_init_tween()

func _init_tween():
	var duration = global_position.length() / float(speed * IDLE_DURATION)
	tween.interpolate_property(self, "position", global_position, move_to, duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "position", move_to, global_position, duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, (duration + IDLE_DURATION * 2))
	tween.start()

func _on_Area2D_body_entered(body):
	if body.is_in_group("programmer"):
		body.stop_on_slope = false

func _on_Area2D_body_exited(body):
	if body.is_in_group("programmer"):
		body.stop_on_slope = true
