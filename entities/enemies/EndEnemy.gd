extends KinematicBody2D

onready var fire_timer = $FireTimer
onready var animation = $Animation

export (PackedScene) var matrix_projectile_scene

var container
var direction = -1
var limit
var init_limit
var max_velocity = 1.5
var fire = true
var dron = false
var velocity = Vector2.ZERO
var speed = 4000

func _ready():
	add_to_group("endEnemy")
	set_physics_process(false)
	set_process(false)

func initialize(_container):
	limit = global_position.x
	init_limit = global_position.x - 1150
	container = _container
	fire_timer.start()
	
func _process(delta):
	velocity.x = clamp(container.dron.global_position.x - global_position.x, -1, 1)
	velocity.y = clamp(container.dron.global_position.y - global_position.y, -1, 1)
	velocity = move_and_slide(velocity * speed * delta, Vector2.ZERO)
	animation.play("antenna")
		
func _physics_process(_delta):
	position.x -= clamp(position.x - container.programmer.global_position.x, -max_velocity, max_velocity)
	position.x = clamp(position.x, init_limit + 60, limit - 25)
	var new_position_y = container.programmer.global_position.y - 350
	position.y = new_position_y if new_position_y < position.y else position.y
	if fire:
		_fire()
		fire_timer.start()
		fire = false

func _fire():
	var proj = matrix_projectile_scene.instance()
	proj.initialize(container, $ProjectilePosition.global_position)
	
func set_drone(condition):
	dron = condition
	if condition:
		set_physics_process(false)
		set_process(true)
	else:
		set_physics_process(true)
		set_process(false)

func start():
	set_physics_process(true)
	
func restart(start_pos):
	set_physics_process(false)
	set_process(false)
	global_position.y = start_pos.y

func _on_FireTimer_timeout():
	fire = true
	
func game_over():
	set_physics_process(false)
	set_process(false)
	hide()

func _on_HitArea_body_entered(body):
	if body.is_in_group("dron"):
		body.hit_end_enemy()
		yield(body.animation, "animation_finished")
		container.dron_hit_end_enemy()
#		call_deferred("_remove")

func _on_Area2D_body_entered(body):
	if body.is_in_group("dron"):
		body.bye()
		container.dead()
