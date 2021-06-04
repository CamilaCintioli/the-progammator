extends KinematicBody2D

signal collided

onready var animation = $AnimationPlayer

var speed = 11

var deacceleration:float = 0.8
var FRICTION_WEIGHT:float = 0.3

var container

var velocity:Vector2 = Vector2.ZERO

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
	velocity = move_and_slide(velocity, Vector2.ZERO)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			emit_signal('collided', collision)

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

func _on_Dron_collided(collision):
	if collision.collider is TileMap:
		container.dead()
		call_deferred("set_game_over")
