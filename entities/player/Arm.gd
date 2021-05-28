extends Sprite

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer

export (PackedScene) var projectile_scene:PackedScene

var container:Node
var can_fire = true

func _fire():
	if can_fire:
		var new_projectile = projectile_scene.instance()
		new_projectile.initialize(container, 
			fire_position.global_position,
			Vector2.UP,
			true)
		can_fire = false
		fire_timer.start()

func _on_Timer_timeout():
	can_fire = true
