extends KinematicBody2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("programmer"):
		body.stop_on_slope = false

func _on_Area2D_body_exited(body):
	if body.is_in_group("programmer"):
		body.stop_on_slope = true
