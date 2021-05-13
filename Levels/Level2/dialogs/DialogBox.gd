extends Control

var container

func initialize(level_2):
	container = level_2

func _on_Solution_area_entered(area):
	if area.is_in_group("while") and container.dialog.visible:
		container.bye_portal()
		
func _remove():
	container.remove_child(self)
	queue_free()
	
func bye():
	call_deferred("_remove")
