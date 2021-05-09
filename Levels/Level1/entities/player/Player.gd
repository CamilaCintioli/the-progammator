extends KinematicBody2D

onready var arm = $Body/Arm

var speed = 450

var container
var screen_size
var x_direction_optimized
var y_direction_optimized

var velocity:Vector2 = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("player")

func initialize(level_1):
	container = level_1
	arm.container = level_1
	
func get_input():
	if Input.is_action_just_pressed("fire"):
		arm._fire()
	
	var right := Input.is_action_pressed("move_right")
	var left := Input.is_action_pressed("move_left")
	x_direction_optimized = int(right) - int(left)
	
	var down := Input.is_action_pressed("move_down")
	var up := Input.is_action_pressed("move_up")
	y_direction_optimized = int(down) - int(up)

func _physics_process(delta):
	get_input()
	
	move_local_x(x_direction_optimized * speed * delta)
	move_local_y(y_direction_optimized * speed * delta)
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	var mouse_position:Vector2 = get_global_mouse_position()
	arm.look_at(mouse_position)
	
func hit():
	print("player hit")
