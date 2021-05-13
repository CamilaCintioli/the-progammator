extends Area2D

var container
var dron

func initialize(level_2, _dron, pos):
	container = level_2
	dron = _dron
	global_position = pos

func _ready():
	set_process(false)
	add_to_group("while")
	
func _process(_delta):
	global_position = dron.codePosition.global_position

func pursue():
	set_process(true)
	
func release():
	set_process(false)
	
func _remove():
	container.remove_child(self)
	queue_free()
	
func bye():
	call_deferred("_remove")
