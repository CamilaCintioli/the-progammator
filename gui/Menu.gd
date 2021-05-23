extends ColorRect

var container

func initialize(_container):
	container = _container

func _on_Start_pressed():
	container.start_level_1()
