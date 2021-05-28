extends KinematicBody2D

onready var fire_timer = $FireTimer

var container
var direction = -1
var limit
var init_limit
var velocity = 1.5
var fire = true

func _ready():
	add_to_group("endEnemy")
	set_physics_process(false)

func initialize(_container):
	limit = global_position.x
	init_limit = global_position.x - 1150
	container = _container
	fire_timer.start()

func _physics_process(_delta):
	position.x -= clamp(position.x - container.programmer.global_position.x, -velocity, velocity)
	position.x = clamp(position.x, init_limit + 60, limit - 25)
	var new_position_y = container.programmer.global_position.y - 350
	position.y = new_position_y if new_position_y < position.y else position.y
	if fire:
		_fire()
		fire_timer.start()
		fire = false

func _fire():
	pass

func start():
	set_physics_process(true)

func _on_FireTimer_timeout():
	fire = true
