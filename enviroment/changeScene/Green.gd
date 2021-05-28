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
