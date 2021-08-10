extends Camera2D

var container

var velocity = 45

func _ready():
	stop()
	
func initialize(_container):
	container = _container

func stop():
	set_process(false)
	current = false

func _start():
	set_process(true)
	current = true

func start():
	call_deferred("_start")

func _process(delta):
	position.y -= velocity * delta
	if container.dron_zone and container.dron.global_position.y < global_position.y - 130.0:
		position.y -= velocity * delta
	if container.dron_zone and container.dron.global_position.y < global_position.y - 230.0:
		position.y -= velocity * delta * 1.5
	if !container.dron_zone and container.programmer.global_position.y < global_position.y - 200.0:
		position.y -= velocity * delta
