extends KinematicBody2D

onready var fire_timer = $FireTimer
onready var animation = $Animation
onready var animation2 = $Animation2
onready var laser := $LaserBeam2D

export (PackedScene) var matrix_projectile_scene

var container
var direction = -1
var limit
var init_limit
var max_velocity = 1.5
var fire = true
var stop_fire = false
var dron = false
var velocity = Vector2.ZERO
var speed = 4000

func _ready():
	add_to_group("endEnemy")
	set_physics_process(false)
	set_process(false)

func initialize(_container):
	limit = global_position.x
	init_limit = global_position.x - 1000
	container = _container
	laser.initialize(_container)
	fire_timer.start()
	
func _process(delta):
	laser.look_at(container.dron.global_position)
	animation2.play("antenna")
	if fire && !stop_fire:
		fire = false
		fire()
		fire_timer.start()
		velocity = Vector2.ZERO
	elif !laser.is_casting:
		velocity.x = clamp(container.dron.global_position.x - global_position.x, -1, 1)
		velocity.y = clamp(container.dron.global_position.y - global_position.y, -1, 1)
		velocity = move_and_slide(velocity * speed * delta, Vector2.ZERO)
		
func _physics_process(_delta):
	laser.look_at(Vector2(laser.global_position.x, laser.global_position.y + 1000))
	position.x -= clamp(position.x - container.programmer.global_position.x, -max_velocity, max_velocity)
	position.x = clamp(position.x, init_limit + 60, limit - 25)
	var new_position_y = container.programmer.global_position.y - 350
	position.y = new_position_y if new_position_y < position.y else position.y
	if fire && !stop_fire:
		fire = false
		fire()
		fire_timer.start()
		velocity = Vector2.ZERO

func stop_laser():
	stop_fire = true
	
func restart_laser():
	yield(get_tree().create_timer(2), "timeout")
	stop_fire = false
	
func _fire():
	var proj = matrix_projectile_scene.instance()
	proj.initialize(container, $ProjectilePosition.global_position)
	
func fire():
	animation.play("screen")
	yield(get_tree().create_timer(2), "timeout")
	animation.play("screen_on")
	laser.is_casting = true
	yield(get_tree().create_timer(2), "timeout")
	laser.is_casting = false
	
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
		yield(body.animation2, "animation_finished")
		container.endEnemy_hit()
#		call_deferred("_remove")
