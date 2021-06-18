extends Node2D

onready var p1 = $GreenPlatform/CollisionPolygon2D
onready var p2 = $GreenPlatform2/CollisionPolygon2D
onready var p3 = $GreenPlatform3/CollisionPolygon2D
onready var p4 = $GreenPlatform4/CollisionPolygon2D
onready var p5 = $GreenPlatform5/CollisionPolygon2D
onready var p6 = $GreenPlatform6/CollisionPolygon2D
onready var p7 = $GreenPlatform7/CollisionPolygon2D
onready var p8 = $GreenPlatform8/CollisionPolygon2D
onready var p9 = $GreenPlatform9/CollisionPolygon2D

onready var a1 = $GreenPlatform/GreenAnimationPlayer
onready var a2 = $GreenPlatform2/GreenAnimationPlayer
onready var a3 = $GreenPlatform3/GreenAnimationPlayer
onready var a4 = $GreenPlatform4/GreenAnimationPlayer
onready var a5 = $GreenPlatform5/GreenAnimationPlayer
onready var a6 = $GreenPlatform6/GreenAnimationPlayer
onready var a7 = $GreenPlatform7/GreenAnimationPlayer
onready var a8 = $GreenPlatform8/GreenAnimationPlayer
onready var a9 = $GreenPlatform9/GreenAnimationPlayer

func _ready():
	disable()

func disable():
	hide()
	p1.disabled = true
	p2.disabled = true
	p3.disabled = true
	p4.disabled = true
	p5.disabled = true
	p6.disabled = true
	p7.disabled = true
	p8.disabled = true
	p9.disabled = true
	
func enable():
	show()
	p1.disabled = false
	p2.disabled = false
	p3.disabled = false
	p4.disabled = false
	p5.disabled = false
	p6.disabled = false
	p7.disabled = false
	p8.disabled = false
	p9.disabled = false


func play():
	a1.play("fade")
	a2.play("fade")
	a3.play("fade")
	a4.play("fade")
	a5.play("fade")
	a6.play("fade")
	a7.play("fade")
	a8.play("fade")
	a9.play("fade")
