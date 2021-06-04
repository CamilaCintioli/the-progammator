extends Node2D

var container
onready var takecoffesound = $AudioTakeCoffee

func initialize(_container):
	container = _container

func _on_PickUpArea_body_entered(body):
	print ("coffee")
	if body.is_in_group("programmer"):
		takecoffesound.play()
		body.pickUpCoffee()
		call_deferred("_remove")

func _remove():
	container.remove_child(self)
	queue_free()
