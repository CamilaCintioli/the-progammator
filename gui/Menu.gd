extends ColorRect

var container

func initialize(_container):
	container = _container

func _on_Start_pressed():
	container.start_level_1()

func _on_Button1_pressed():
	CheckpointsMenu.set_check(1)
	container.start_level_1()

func _on_Button2_pressed():
	CheckpointsMenu.set_check(2)
	container.start_level_1()

func _on_Button3_pressed():
	CheckpointsMenu.set_check(3)
	container.start_level_1()

func _on_Button4_pressed():
	CheckpointsMenu.set_check(4)
	container.start_level_1()

func _on_Button5_pressed():
	CheckpointsMenu.set_check(5)
	container.start_level_1()
