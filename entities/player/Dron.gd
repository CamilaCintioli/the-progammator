extends KinematicBody2D

signal collided

onready var animation = $AnimationPlayer

var speed = 11

var deacceleration:float = 0.8
var FRICTION_WEIGHT:float = 0.3

var container

var velocity:Vector2 = Vector2.ZERO
var VELOCITY_TO_CRASH = 90.0
var v_x = 0.0
var v_y = 0.0
var upOrDown = false

func _ready():
	add_to_group("dron")

func initialize(_container):
	container = _container
	
func get_input():
	var right := Input.is_action_pressed("move_right")
	var left := Input.is_action_pressed("move_left")
	velocity.x += clamp(float(right) - float(left), -FRICTION_WEIGHT, FRICTION_WEIGHT) * speed
	
	var down := Input.is_action_pressed("move_down")
	var up := Input.is_action_pressed("move_up")
	velocity.y += clamp(float(down) - float(up), -FRICTION_WEIGHT, FRICTION_WEIGHT) * speed

func _physics_process(_delta):
	if !container.control:
		get_input()
	else:
		velocity.x = deaccelerate_x()
		velocity.y = deaccelerate_y()
	v_x = velocity.x + 0.0
	v_y = velocity.y + 0.0
	velocity.y -= $Sprite.rotation_degrees/10
	velocity = move_and_slide(velocity, Vector2.ZERO)
	collision_with_tile_map(v_x, v_y, upOrDown)
	
func collision_with_tile_map(vel_x, vel_y, up_or_down):
	for i in get_slide_count():
		var tile: bool = get_slide_collision(i).collider is TileMap
		if tile and (abs(vel_x) > VELOCITY_TO_CRASH or abs(vel_y) > VELOCITY_TO_CRASH):
			emit_signal('collided')
		elif tile and up_or_down:
			velocity.y = vel_y * -1
			$Sprite.rotation_degrees = clamp($Sprite.rotation_degrees - 3, -20, 20)
			animation.play("sparks")
		elif tile and !up_or_down:
			velocity.x = vel_x * -1
			$Sprite.rotation_degrees = clamp($Sprite.rotation_degrees - 3, -20, 20)
			animation.play("sparks")

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
	
func come_back():
	call_deferred("set_game_on")
	
func set_game_on():
	set_physics_process(true)
	$CollisionShape2D.disabled = false
	visible = true
	
func bye_collision():
	$CollisionShape2D.disabled = true
	
func set_game_over():
	set_physics_process(false)
	velocity = Vector2.ZERO
	visible = false
	call_deferred("bye_collision")
	
func restart():
	v_x = 0.0
	v_y = 0.0
	upOrDown = false
	$Sprite.rotation_degrees = 0
	
func end_position(pos):
	global_position = pos
	bye()
	
func hit_end_enemy():
	animation.play("rayo")
#	yield($AnimationPlayer, "animation_finished")

func bye():
	call_deferred("set_game_over")

func _on_VisibilityNotifier2D_screen_exited():
	if (!container.change or container.dron_zone) and container.upCamera.current:
		container.dead()
		call_deferred("set_game_over")

func _on_Dron_collided():
	container.dead()
	call_deferred("set_game_over")

func _on_UpDown_body_entered(body):
	if body is TileMap:
		upOrDown = true

func _on_UpDown_body_exited(body):
	if body is TileMap:
		upOrDown = false
