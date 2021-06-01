extends Camera2D

var velocity = 45

func _ready():
	stop()

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
