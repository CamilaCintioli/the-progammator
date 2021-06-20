extends Sprite

onready var timer = $Timer
onready var sound = $Audio

var sections:int = 900
var on = false
var times = 0

func _ready():
	set_process(false)
	timer.start()
	sound.play()
	
func _unhandled_input(_event):
	if Input.is_action_pressed("start"):
		get_tree().change_scene("res://menu/DroneMenu.tscn")

func _process(_delta):
	sections += 1
	material.set_shader_param("tearing", 0.015)
	material.set_shader_param("sections", float(sections) * 0.01)

func _on_Timer_timeout():
	on = !on
	set_process(on)
	if on:
		material.set_shader_param("sections", float(sections) * 0.02)
	else:
		material.set_shader_param("sections", 0.0)
	timer.start()

func _on_Audio_finished():
	sound.play()
