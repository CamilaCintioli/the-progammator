extends StaticBody2D

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer

export (PackedScene) var projectile_scene

var target
var container

func _ready():
	add_to_group("robot")

func initialize(_container):
	container = _container

func _on_DetectionArea_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		target = body
		fire_timer.start()

func _on_DetectionArea_body_exited(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		target = null
		fire_timer.stop()

func _on_HeadArea_body_entered(body):
	if body.is_in_group("dron"):
		call_deferred("_remove")

func _on_HitArea_body_entered(body):
	if body.is_in_group("dron"):
		call_deferred("_remove")

func _remove():
	container.remove_child(self)
	queue_free()

func _on_FireTimer_timeout():
	fire()
	
func fire():
	if target != null:
		var proj_instance = projectile_scene.instance()
		proj_instance.initialize(container, 
			fire_position.global_position, 
			fire_position.global_position.direction_to(target.global_position),
			false)
		fire_timer.start()
