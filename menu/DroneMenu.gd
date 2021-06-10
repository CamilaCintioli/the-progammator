extends Sprite

onready var timer = $Timer

var sections:int = 900
var on = false
var times = 0

func _ready():
	set_process(false)
	timer.start()

func _process(delta):
	sections += 1
	material.set_shader_param("tearing", 0.015)
	material.set_shader_param("sections", float(sections) * 0.01)

func _on_Timer_timeout():
	on = !on
	times += 1
	if times == 7:
		set_process(false)
		get_tree().change_scene("res://Game.tscn")
	set_process(on)
	if on:
		material.set_shader_param("sections", float(sections) * 0.02)
	else:
		material.set_shader_param("sections", 0.0)
	timer.start()
