extends StaticBody2D

onready var fire_timer = $Timer

export (PackedScene) var matrix_projectile_scene

var container

func _ready():
	add_to_group("turret")

func initialize(_container, turret_pos):
	self.container = _container
	container.add_child(self)
	global_position = turret_pos
	fire_timer.wait_time = rand_range(1,5)
	fire_timer.start()
	
func _shoot():
	var proj = matrix_projectile_scene.instance()
	proj.initialize(container, global_position, Vector2.DOWN, false)

func _on_Timer_timeout():
	_shoot()
