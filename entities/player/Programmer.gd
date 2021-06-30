extends KinematicBody2D

const FLOOR_NORMAL := Vector2.UP
const SNAP_DIRECTION := Vector2.DOWN
const SNAP_LENGTH := 32.0
const SLOPE_THRESHOLD := deg2rad(60)

onready var arm = $Arm
onready var sm = $ProgrammerStateMachine
onready var animation = $AnimationPlayer
onready var anim2 = $AnimationPlayer2
onready var audio_stream = $ProgrammerSounds
onready var body = $Sprite

export (float) var ACCELERATION:float = 20.0
export (float) var H_SPEED_LIMIT:float = 200.0
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity:float = 14
export (int) var jump_speed:float = 500

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGTH
var move_direction:int = 0
var stop_on_slope:bool = true
var container
var bounce = 0
var laser_hitted:bool = false
var within_distance:bool = false

func _ready():
	sm.initialize(self)
	add_to_group("programmer")

func initialize(_container):
	self.container = _container
	arm.container = _container
	
func get_input():
	move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	_set_animation(move_direction)
	
func _handle_actions():
	if container.final:
		_check_distance()
	if Input.is_action_just_pressed("change") and !container.chrom_dead:
		if container.end_game:
			arm._fire()
		elif !container.change_zone and !container.dron_zone:
			container.change_control()

func _set_animation(h_movement_direction):
	if h_movement_direction != 0 and int(!$Sprite.flip_h) != h_movement_direction:
		$Sprite.flip_h = h_movement_direction < 0

func _check_distance():
	var dron_distance = container.dron.global_position - global_position
	var distance = abs(dron_distance.x) + abs(dron_distance.y)
	if distance < container.dron.disconnect_distance:
		if !within_distance:
			container.dron.set_game_on()
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

func hit():
	container.livesDecrease()
	
func enemy_hit():
	laser_hit()
	
func laser_hit():
	if !laser_hitted:
		container.livesDecrease()
		laser_hitted = true
		anim2.play("hit")
		yield(anim2, "animation_finished")
		laser_hitted = false
	
func update_position(pos):
	snap_vector = Vector2.ZERO
	velocity = Vector2.ZERO
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
	
func _handle_move_input():
	if container.control and (!container.dron_zone or !container.change_zone):
		get_input()

func _handle_acceleration(multiplier:float = 1.0):
	if move_direction != 0 and container.control:
		velocity.x = clamp(velocity.x + (move_direction * ACCELERATION * multiplier), -H_SPEED_LIMIT * multiplier, H_SPEED_LIMIT * multiplier)
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0

func _apply_movement():
	velocity.y += gravity
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, stop_on_slope, 4, SLOPE_THRESHOLD).y
	if is_on_floor() && snap_vector == Vector2.ZERO:
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH

func _play_animation(animation_name:String, should_restart:bool = true, playback_speed:float = 1.0, play_backwards:bool = false):
	if should_restart:
		animation.stop()
	animation.playback_speed = playback_speed
	if play_backwards:
		animation.play_backwards(animation_name)
	else:
		animation.play(animation_name)

func _is_animation_playing(animation_name:String)->bool:
	return animation.current_animation == animation_name && animation.is_playing()

func _remove():
	set_physics_process(false)
	hide()
