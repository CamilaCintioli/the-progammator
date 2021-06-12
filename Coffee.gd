extends Node2D

var container
var audiostream

func initialize(_container, audio_stream):
	container = _container
	audiostream = audio_stream

func _on_PickUpArea_body_entered(body):
	if body.is_in_group("programmer"):
		audiostream.stream = audiostream.coffee_take
		audiostream.play()
		body.pickUpCoffee()
		hide()
		call_deferred("_remove")

func _remove():
	container.remove_child(self)
	queue_free()
