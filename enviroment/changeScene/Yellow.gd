extends Node2D

onready var p1 = $YellowPlatform/CollisionPolygon2D
onready var p2 = $YellowPlatform2/CollisionPolygon2D
onready var p3 = $YellowPlatform3/CollisionPolygon2D
onready var p4 = $YellowPlatform4/CollisionPolygon2D
onready var p5 = $YellowPlatform5/CollisionPolygon2D
onready var p6 = $YellowPlatform6/CollisionPolygon2D
onready var p7 = $YellowPlatform7/CollisionPolygon2D
onready var p8 = $YellowPlatform8/CollisionPolygon2D
onready var p9 = $YellowPlatform9/CollisionPolygon2D

onready var a1 = $YellowPlatform/AnimationPlayer
onready var a2 = $YellowPlatform2/AnimationPlayer
onready var a3 = $YellowPlatform3/AnimationPlayer
onready var a4 = $YellowPlatform4/AnimationPlayer
onready var a5 = $YellowPlatform5/AnimationPlayer
onready var a6 = $YellowPlatform6/AnimationPlayer
onready var a7 = $YellowPlatform7/AnimationPlayer
onready var a8 = $YellowPlatform8/AnimationPlayer
onready var a9 = $YellowPlatform9/AnimationPlayer

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
