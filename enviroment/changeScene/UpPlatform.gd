extends StaticBody2D

func _ready():
	stop()

func stop():
	set_process(false)
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	$CollisionShape2D3.disabled = true

func _start():
	set_process(true)
	$CollisionPolygon2D.disabled = false
	$CollisionShape2D.disabled = false
	$CollisionShape2D2.disabled = false
	$CollisionShape2D3.disabled = false
	
func start():
	call_deferred("_start")

func _process(delta):
	position.x += 80 * delta
	position.y -= 80 * delta
	if position.y < 800:
		call_deferred("stop")
