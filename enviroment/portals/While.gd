extends Area2D

func _remove():
	get_parent().remove_child(self)
	queue_free()
	
func bye():
	call_deferred("_remove")

func _on_Bug_body_entered(body):
	if body.is_in_group("programmer"):
		get_parent().bug()
		bye()
