extends Area2D

var container

func initialize(level_2):
	container = level_2

func _on_Portal_body_entered(body):
	if body.is_in_group("programmer"):
		container.show_dialog()

func _on_Portal_body_exited(body):
	if body.is_in_group("programmer"):
		container.hide_dialog()
		
func bye():
	container.remove_child(self)
	queue_free()
