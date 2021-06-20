extends StaticBody2D

onready var timer = $Timer
onready var animation = $AnimationPlayer

var target = false

func _remove():
	animation.play("fade")
	yield(animation, "animation_finished")
	get_parent().remove_child(self)
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("programmer"):
		timer.start()

func _on_Timer_timeout():
	call_deferred("_remove")
