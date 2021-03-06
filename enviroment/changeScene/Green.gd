extends Node2D

onready var p2 = $GreenPlatform2/CollisionPolygon2D
onready var p3 = $GreenPlatform3/CollisionPolygon2D
onready var p4 = $GreenPlatform4/CollisionPolygon2D

onready var a2 = $GreenPlatform2/GreenAnimationPlayer
onready var a3 = $GreenPlatform3/GreenAnimationPlayer
onready var a4 = $GreenPlatform4/GreenAnimationPlayer

func _ready():
	disable()

func disable():
	hide()
	p2.disabled = true
	p3.disabled = true
	p4.disabled = true
	
func enable():
	show()
	p2.disabled = false
	p3.disabled = false
	p4.disabled = false

func play():
	a2.play("fade")
	a3.play("fade")
	a4.play("fade")
