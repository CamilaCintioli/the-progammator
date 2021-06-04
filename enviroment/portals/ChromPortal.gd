extends StaticBody2D

func _remove(container):
	container.remove_child(self)
	queue_free()

func bye(container):
	call_deferred("_remove", container)
