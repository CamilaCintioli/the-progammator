extends Node2D

var container

func initialize(_container):
	container = _container

func _on_PickUpArea_body_entered(body):
		body.pickUpCoffee()
		call_deferred("_remove")

func _remove():
	container.remove_child(self)
	queue_free()
