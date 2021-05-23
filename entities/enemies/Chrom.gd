extends KinematicBody2D

export (PackedScene) var matrix_projectile_scene

onready var fire_timer = $FireTimer

var container
var direction = -1
var limit

func _ready():
	add_to_group("chrom")

func initialize(_limit, _container):
	limit = _limit.global_position.x
	container = _container
	fire_timer.wait_time = 2 #rand_range(1,5)
	fire_timer.start()

func _physics_process(_delta):
	$AnimationChrom.play("roll")
	position.x += 4 * direction;
	position.x = wrapf(position.x, 0, limit)
	
func _on_Timer_timeout():
	direction *= -1
	
func game_over():
	set_physics_process(false)
	hide()
	
func _remove():
	container.remove_child(self)
	queue_free()
	
func bye():
	call_deferred("game_over")

func _shoot():
	var proj = matrix_projectile_scene.instance()
	proj.initialize(container, global_position, Vector2.DOWN, false)

func _on_FireTimer_timeout():
	_shoot()
