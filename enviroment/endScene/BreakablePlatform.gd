extends KinematicBody2D

func _bye():
	hide()
	$CollisionPolygon2D.disabled = true
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_on_floor() && body.position.y < global_position.y:
		call_deferred("_bye")
