extends Node2D

onready var p1 = $GreenPlatform/CollisionPolygon2D
onready var p2 = $GreenPlatform2/CollisionPolygon2D
onready var p3 = $GreenPlatform3/CollisionPolygon2D

onready var a1 = $GreenPlatform/GreenAnimationPlayer
onready var a2 = $GreenPlatform2/GreenAnimationPlayer
onready var a3 = $GreenPlatform3/GreenAnimationPlayer

func _ready():
	disable()

func disable():
	hide()
	p1.disabled = true
	p2.disabled = true
	p3.disabled = true
	
func enable():
	show()
	p1.disabled = false
	p2.disabled = false
	p3.disabled = false

func play():
	a1.play("fade")
	a2.play("fade")
	a3.play("fade")
