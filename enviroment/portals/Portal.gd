extends Area2D

var container

onready var anim = $AnimationPlayer
onready var anim2 = $AnimationPlayer2

func _ready():
	anim.play("portal-spin")

	anim2.play("light-portal")

func initialize(level_2):
	container = level_2

func _on_Portal_body_entered(body):
	if body.is_in_group("programmer") and container.there_are_bugs():
		container.show_dialog()
	elif body.is_in_group("programmer") and !container.there_are_bugs():
		container.bye_portal()

func _on_Portal_body_exited(body):
	if body.is_in_group("programmer"):
		container.hide_dialog()
		
func _remove():
	container.remove_child(self)
	queue_free()
	
func bye():
	call_deferred("_remove")
