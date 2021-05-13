extends Area2D

var container

func initialize(level_2):
	container = level_2

func _on_Portal_body_entered(body):
	if body.is_in_group("programmer"):
		get_parent().show_dialog()

func _on_Portal_body_exited(body):
	if body.is_in_group("programmer"):
		get_parent().hide_dialog()
