extends KinematicBody2D

export (PackedScene) var matrix_projectile_scene

onready var fire_timer = $FireTimer
onready var anim_chrom = $AnimationChrom

var container
var direction = -1
var limit

func _ready():
	add_to_group("chrom")

func initialize(_limit, _container):
	limit = _limit.global_position.x
	container = _container
	
func start():
	fire_timer.wait_time = 0.8
	fire_timer.start()

func _physics_process(_delta):
	anim_chrom.play("roll")
	position.x += 4 * direction;
	position.x = wrapf(position.x, 0, limit)
	
func _on_Timer_timeout():
	direction *= -1
	
func game_over():
	set_physics_process(false)
	fire_timer.stop()
	anim_chrom.play("remove")
	yield(anim_chrom, "animation_finished")
	hide()
	
func _remove():
	container.remove_child(self)
	queue_free()
	
func bye():
	$chromSprite.scale = $chromSprite.scale * 1.2
	container.chrom_hit()
	#call_deferred("game_over") # se llama con game e interface

func _shoot():
	var proj = matrix_projectile_scene.instance()
	proj.initialize(container, global_position, Vector2.DOWN, false)

func _on_FireTimer_timeout():
	_shoot()
