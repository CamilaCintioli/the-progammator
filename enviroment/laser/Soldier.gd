extends KinematicBody2D

onready var timer = $Timer
var speed = 250
var velocity = Vector2()
var damage = false
export var beam_duration = 1.8
export var cooldown = 0.2
var hit = null
var target = false
	
func _ready():
	set_process(false)
	$Line2D.remove_point(1)
	
func _process(_delta):
	$LaserAudio.play()
	
func shoot():
	damage = true
	set_process(true)
	hit = cast_beam()
	yield(get_tree().create_timer(beam_duration), "timeout")
	$Line2D.remove_point(1)
	hit = null
	damage = false
	target = true
	yield(get_tree().create_timer(cooldown), "timeout")
	set_process(false)
	
func cast_beam():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray($Muzzle.global_position, $Muzzle.global_position + transform.x * 1000, [self])
	if result:
		if target and (result.collider.name == "Dron" or result.collider.name == "Programmer"):
			target = false
			get_parent().livesDecrease()
		if !hit:
			$Line2D.add_point(transform.xform_inv(result.position))
		else:
			$Line2D.set_point_position(1, transform.xform_inv(result.position))
	return result

func _on_Timer_timeout():
	shoot()
	timer.start()

func _on_Area2D_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		timer.start()

func _on_Area2D_body_exited(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		timer.stop()

func _on_HitArea_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		target = true
		if damage:
			get_parent().livesDecrease()

func _on_HitArea_body_exited(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		target = false
