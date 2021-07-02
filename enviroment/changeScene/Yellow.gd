extends Node2D

onready var p2 = $YellowPlatform2/CollisionPolygon2D
onready var p3 = $YellowPlatform3/CollisionPolygon2D

onready var a2 = $YellowPlatform2/AnimationPlayer
onready var a3 = $YellowPlatform3/AnimationPlayer

func disable():
	hide()
	p2.disabled = true
	p3.disabled = true

func enable():
	show()
	p2.disabled = false
	p3.disabled = false

func play():
	a2.play("fade")
	a3.play("fade")
