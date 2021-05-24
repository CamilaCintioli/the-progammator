extends KinematicBody2D

const FLOOR_NORMAL := Vector2.UP
const SNAP_DIRECTION := Vector2.UP
const SNAP_LENGHT := 32.0
const SLOPE_THRESHOLD := deg2rad(46)

onready var arm = $Arm

export (float) var ACCELERATION:float = 20.0
export (float) var H_SPEED_LIMIT:float = 200.0
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity:float = 10
export (int) var jump_speed:float = 350

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGHT
var container

func _ready():
	add_to_group("programmer")

func initialize(_container):
	self.container = _container
	arm.container = _container

func get_input():
	# Jump action
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_speed
	# Fire action
	if Input.is_action_just_pressed("fire"):
		arm._fire()
	# Horizontal speed
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	
	_set_animation(h_movement_direction)

func _set_animation(h_movement_direction):
	if h_movement_direction != 0 and int(!$Sprite.flip_h) != h_movement_direction:
		$Sprite.flip_h = h_movement_direction < 0

func _physics_process(_delta):
	if Input.is_action_just_pressed("change"):
		container.change_control()
	
	if container.control:
		get_input()
	else:
		velocity = Vector2.ZERO
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
func hit():
	container.livesDecrease()

func set_game_over():
	set_physics_process(false)
	hide()

func _on_VisibilityNotifier2D_screen_exited():
	if container.endCamera.current:
		container.dead()
		call_deferred("set_game_over")
