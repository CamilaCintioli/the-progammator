extends KinematicBody2D

var speed = 11

var deacceleration:float = 0.8
var FRICTION_WEIGHT:float = 0.3

var container
var game_over = false

var velocity:Vector2 = Vector2.ZERO

func _ready():
	add_to_group("dron")

func initialize(level_2):
	container = level_2
	
func get_input():
	var right := Input.is_action_pressed("move_right")
	var left := Input.is_action_pressed("move_left")
	velocity.x += clamp(float(right) - float(left), -FRICTION_WEIGHT, FRICTION_WEIGHT) * speed
	
	var down := Input.is_action_pressed("move_down")
	var up := Input.is_action_pressed("move_up")
	velocity.y += clamp(float(down) - float(up), -FRICTION_WEIGHT, FRICTION_WEIGHT) * speed

func _physics_process(_delta):
	if !game_over:
		if !container.control:
			get_input()
		else:
			velocity.x = deaccelerate_x()
			velocity.y = deaccelerate_y()
		velocity = move_and_slide(velocity, Vector2.ZERO)

func deaccelerate_x() -> float:
	if velocity.x < deacceleration and velocity.x > -deacceleration:
		return 0.0
	else:
		return velocity.x + deacceleration if velocity.x < 0 else velocity.x - deacceleration

func deaccelerate_y() -> float:
	if velocity.y < deacceleration and velocity.y > -deacceleration:
		return 0.0
	else:
		return velocity.y + deacceleration if velocity.y < 0 else velocity.y - deacceleration

func hit():
	container.livesDecrease()

func set_game_over():
	game_over = true
	hide()
