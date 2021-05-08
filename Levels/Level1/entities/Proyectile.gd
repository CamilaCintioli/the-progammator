extends Area2D

onready var life_timer = $LifeTimer

export (float) var VELOCITY:float = 300.0

var container
var direction:Vector2

func initialize(container, spawn_position:Vector2, direction:Vector2):
	self.container = container
	container.add_child(self) 
	global_position = spawn_position
	self.direction = direction
	life_timer.connect("timeout", self, "_on_life_timer_timeout")
	life_timer.start()

func _physics_process(delta):
	position += direction * VELOCITY * delta
	
func _remove():
	container.remove_child(self)
	queue_free()

func _on_life_timer_timeout():
	_remove()
