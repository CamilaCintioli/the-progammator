extends KinematicBody2D

const FLOOR_NORMAL := Vector2.UP
const SNAP_DIRECTION := Vector2.UP
const SNAP_LENGHT := 32.0
const SLOPE_THRESHOLD := deg2rad(46)
const BOUNCING_JUMP = 155

onready var arm = $Arm

onready var animation = $AnimationPlayer
onready var audio_stream = $ProgrammerSounds

export (float) var ACCELERATION:float = 20.0
export (float) var H_SPEED_LIMIT:float = 200.0
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity:float = 10
export (int) var jump_speed:float = 430

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGHT
var container
var bounce = 0
var laser_hitted:bool = false


var within_distance:bool = false

func _ready():
	add_to_group("programmer")

func initialize(_container):
	self.container = _container
	arm.container = _container

func get_input():
	var x_bounce = 0
	# Horizontal speed
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var on_floor = is_on_floor()
	if h_movement_direction != 0 and !Input.is_action_just_pressed("jump"):
		if on_floor:
			animation.play("walk")
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT) + x_bounce
	elif on_floor:
		animation.play("idle")
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	if Input.is_action_just_pressed("jump") and on_floor:
		velocity.y -= jump_speed
		animation.play("jump")
		audio_stream.jump()
	_set_animation(h_movement_direction)

func _set_animation(h_movement_direction):
	if h_movement_direction != 0 and int(!$Sprite.flip_h) != h_movement_direction:
		$Sprite.flip_h = h_movement_direction < 0

func _check_distance():
	var dron_distance = container.dron.global_position - global_position
	var distance = abs(dron_distance.x) + abs(dron_distance.y)
	if distance < container.dron.disconnect_distance:
		if !within_distance:
			container.dron.set_game_on()
			container.interface.display_connection(1)
			within_distance = true
		if distance > container.dron.disconnect_distance:
			container.set_connection(0)
		elif distance > container.dron.extreme_distance_to_glitch:
			container.set_connection(1)
		elif distance > container.dron.distance_to_glitch:
			container.set_connection(2)
		else:
			container.set_connection(3)
	elif distance > container.dron.disconnect_distance:
		within_distance = false
	
	
func _physics_process(_delta):
	if container.final:
		_check_distance()
	if Input.is_action_just_pressed("change") and !container.chrom_dead:
		if container.end_game:
			arm._fire()
		elif !container.change_zone and !container.dron_zone:
			container.change_control()
	
	if container.control and (!container.dron_zone or !container.change_zone):
		get_input()
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
	velocity.y += gravity
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
func hit():
	container.livesDecrease()
	
func laser_hit():
	if !laser_hitted:
		container.livesDecrease()
		laser_hitted = true
		yield(get_tree().create_timer(0.3), "timeout")
		$Sprite.visible = false
		yield(get_tree().create_timer(0.3), "timeout")
		$Sprite.visible = true
		yield(get_tree().create_timer(0.3), "timeout")
		$Sprite.visible = false
		yield(get_tree().create_timer(0.3), "timeout")
		$Sprite.visible = true
		yield(get_tree().create_timer(0.3), "timeout")
		$Sprite.visible = false
		yield(get_tree().create_timer(0.3), "timeout")
		$Sprite.visible = true
		yield(get_tree().create_timer(0.3), "timeout")
		laser_hitted = false
	
func update_position(pos):
	global_position = pos

func set_game_over():
	set_physics_process(false)
	hide()

func _on_VisibilityNotifier2D_screen_exited():
	if container.control and container.final:
		if container.endCamera.current or (container.upCamera.current and container.change_zone):
			container.dead()
			call_deferred("set_game_over")

func pickUpCoffee():
	container.livesIncrease()
