extends Area2D

var container

onready var sound = $DoorStreamPlayer2D
onready var anim = $AnimationPlayer
var has_opened = false


func _ready():

	pass
	
func initialize(level_2):
	container = level_2

func _on_Portal_body_entered(body):
	if body.is_in_group("programmer") and container.there_are_bugs():
		container.show_dialog()
		sound.stream = sound.door_error
		sound.play()
		
	elif body.is_in_group("programmer") and !container.there_are_bugs():
		container.bye_portal()
		has_opened = true
		sound.stream = sound.door_open
		sound.play()
		anim.play("open")
		
	elif body.is_in_group("dron") and !has_opened:
		sound.stream = sound.door_error
		sound.play()
	
	elif body.is_in_group("dron") and has_opened:
		sound.stream = sound.door_open
		sound.play()
		anim.play("open")

func _on_Portal_body_exited(body):
	if body.is_in_group("programmer") and !container.there_are_bugs():
		container.hide_dialog()
		anim.play("close")
	elif body.is_in_group("dron") and has_opened:
		anim.play("close")
		
func _remove():
	container.remove_child(self)
	queue_free()
	
func bye():
	#call_deferred("_remove")
	#$CollisionShape2D.set_deferred("disabled", true)
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
