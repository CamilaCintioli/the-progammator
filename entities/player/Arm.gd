extends Sprite

onready var fire_position = $FirePosition

export (PackedScene) var projectile_scene:PackedScene

var container:Node

func _fire():
	var new_projectile = projectile_scene.instance()
	new_projectile.initialize(container, 
		fire_position.global_position,
		Vector2.UP,
		true)
