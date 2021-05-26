extends Node2D

onready var p1 = $YellowPlatform/CollisionPolygon2D
onready var p2 = $YellowPlatform2/CollisionPolygon2D
onready var p3 = $YellowPlatform3/CollisionPolygon2D
onready var p4 = $YellowPlatform4/CollisionPolygon2D
onready var p5 = $YellowPlatform5/CollisionPolygon2D
onready var p6 = $YellowPlatform6/CollisionPolygon2D

func disable():
	hide()
	p1.disabled = true
	p2.disabled = true
	p3.disabled = true
	p4.disabled = true
	p5.disabled = true
	p6.disabled = true

func enable():
	show()
	p1.disabled = false
	p2.disabled = false
	p3.disabled = false
	p4.disabled = false
	p5.disabled = false
	p6.disabled = false
