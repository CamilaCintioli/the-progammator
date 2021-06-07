extends StaticBody2D

func _ready():
	$CollisionShape2D.disabled = true

func _remove(container):
	container.remove_child(self)
	queue_free()

func bye(container):
	call_deferred("_remove", container)
	
func set_on():
	call_deferred("start_collision")
	
func start_collision():
	$CollisionShape2D.disabled = false
	
func stop_collision():
	call_deferred("stop_c")
	
func stop_c():
	$CollisionShape2D.disabled = true
