extends KinematicBody2D

onready var collision = $CollisionShape2D
onready var tween = $Tween
onready var target_timer = $TargetTimer
onready var animation = $AnimationPlayer

const MARGIN_PLATFORM = 150
const IDLE_DURATION = 0.55
export var move_to = Vector2.RIGHT
export var speed = 2850.0

var target = null

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
		target = body
		body.explosion()
		target_timer.start()
		
func _remove():
	$BodyArea/CollisionShape2D.disabled = true
	$HeadArea/CollisionShape2D.disabled = true
	animation.play("dead")
	yield(animation, "animation_finished")
	get_parent().remove_child(self)
	queue_free()

func _on_HeadArea_body_entered(body):
	if body.is_in_group("dron"):
		body.explosion()
	if body.is_in_group("programmer"):
		get_parent().play_robot_killed_sound()
		call_deferred("_remove")

func _on_TargetTimer_timeout():
	if target:
		target.explosion()
		target_timer.start()

func _on_BodyArea_body_exited(body):
	if (body.is_in_group("programmer") or body.is_in_group("dron")) and target:
		target = null
