extends Area2D

onready var sound = $AudioStreamPlayer2D
onready var anim = $AnimationPlayer
onready var timer = $DialogTimer
var has_entered = false
var _container 
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("bounce")
	
func initialize(container):
	_container = container
	
func show_dialog(value):
	if(value):
		$Panel.show()
	else:
		$Panel.hide()
	

func _on_CPlus_body_entered(body):
	if(!has_entered):
		if body.is_in_group("programmer") :
			sound.play()
			show_dialog(true)
			anim.play("text")
			timer.start()
		_container.add_ram()

func _on_DialogTimer_timeout():
	anim.play("bounce")
