extends Area2D

func _remove():
	get_parent().remove_child(self)
	queue_free()
	
func bye():
	call_deferred("_remove")
