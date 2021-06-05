extends KinematicBody2D

export (PackedScene) var matrix_projectile_scene

onready var fire_timer = $FireTimer
onready var anim_chrom = $AnimationChrom
onready var tween = $Tween

var container
var direction = -1
var limit
var started = false

const IDLE_DURATION = 0.45
export var move_to = Vector2.RIGHT
export var speed = 2000.0

func _ready():
	add_to_group("chrom")
	
func initialize(_limit, _container):
	container = _container
	move_to = Vector2(_limit.global_position.x, global_position.y)

func _init_tween():
	var duration = global_position.length() / float(speed * IDLE_DURATION)
	tween.interpolate_property(self, "position", global_position, move_to, duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "position", move_to, global_position, duration, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT, (duration + IDLE_DURATION * 2))
	tween.start()

func start():
	if !started:
		started = true
		_init_tween()
		set_physics_process(true)
		fire_timer.wait_time = 0.8
		fire_timer.start()

func _physics_process(_delta):
	anim_chrom.play("roll")
	
func _on_Timer_timeout():
	direction *= -1
	
func game_over():
	set_physics_process(false)
	fire_timer.stop()
	tween.stop_all()
	anim_chrom.play("remove")
	yield(anim_chrom, "animation_finished")
	container.set_camera_player()
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
