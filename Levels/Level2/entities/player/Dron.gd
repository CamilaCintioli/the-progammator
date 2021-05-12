extends KinematicBody2D

var speed = 9

var FRICTION_WEIGHT:float = 0.1

var container

var velocity:Vector2 = Vector2.ZERO

func _ready():
	add_to_group("dron")

func initialize(level_2):
	container = level_2
	
func get_input():
	
	var right := Input.is_action_pressed("move_right")
	var left := Input.is_action_pressed("move_left")
	velocity.x += lerp(float(right) - float(left), 0.2, 0.2) * speed 
	
	var down := Input.is_action_pressed("move_down")
	var up := Input.is_action_pressed("move_up")
	velocity.y += lerp(float(down) - float(up), 0.2, 0.2) * speed 
	

func _physics_process(delta):
	if !container.control:
		get_input()
	velocity = move_and_slide(velocity, Vector2.ZERO)
