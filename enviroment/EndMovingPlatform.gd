extends Node2D

const IDLE_DURATION:float = 1.0

onready var move_to = Vector2.UP * ($EndPos.position.y/2) * -1
export (float) var speed = 70.0

onready var platform = $Platform
onready var tween = $Tween
onready var anim = $AnimationPlatform

var follow:Vector2 = Vector2.ZERO

func move():
	_init_tween()
	anim.play("glow")

func _init_tween():
	var duration = move_to.length() / float(speed)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	#tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()

func _physics_process(_delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)

func stop():
	anim.stop()
	

