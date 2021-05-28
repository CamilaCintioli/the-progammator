extends StaticBody2D

onready var fire_timer = $Timer

export (PackedScene) var matrix_projectile_scene

var container

func _ready():
	add_to_group("turret")
	
func _add():
	container.add_child(self)
	fire_timer.wait_time = rand_range(1,5)
	fire_timer.start()
	#Conectando la señal de game para parar los disparos 
	container.connect("stop_shooting", self, "_on_stop_shooting")

func initialize(_container, turret_pos):
	self.container = _container
	global_position = turret_pos
	call_deferred("_add")
	
func _shoot():
	var proj = matrix_projectile_scene.instance()
	proj.initialize(container, global_position, Vector2.DOWN, false)

func _on_Timer_timeout():
	_shoot()
	
func _on_stop_shooting():
	fire_timer.stop()
