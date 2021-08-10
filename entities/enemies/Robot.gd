extends StaticBody2D

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer
onready var player_timer = $PlayerTimer

export (PackedScene) var projectile_scene

var target
var container
var player = null

var shooting_left = false
var shooting_right = false

func _ready():
	add_to_group("robot")
	$PositionTimer.wait_time = rand_range(3, 7)
	$PositionTimer.start()
	$FireTimer.start()

func initialize(_container):
	container = _container

func _on_HeadArea_body_entered(body):
	if body.is_in_group("dron"):
		body.hit_end_enemy()
		yield(body.animation2, "animation_finished")
		call_deferred("_remove")
	if body.is_in_group("programmer"):
		container.play_robot_killed_sound()
		call_deferred("_remove")

func _on_HitArea_body_entered(body):
	if body.is_in_group("dron") or body.is_in_group("programmer"):
		player = body
		body.explosion()
		player_timer.start()

func _remove():
	container.remove_child(self)
	queue_free()

func _on_FireTimer_timeout():
	fire()
	$FireTimer.start()
	
func shoot():
	var proj_instance = projectile_scene.instance()
	proj_instance.initialize(container, 
		fire_position.global_position, 
		fire_position.global_position.direction_to(target.global_position),
		false)
	fire_timer.start()
	
func fire():
	if !container.is_game_over and can_shoot():
		shoot()
		
func can_shoot():
	return (target != null and $Sprite.flip_h and shooting_left) or (target != null and !$Sprite.flip_h and shooting_right)

func _on_DetectionAreaLeft_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		shooting_left = true
		if !target:
			target = body

func _on_DetectionAreaLeft_body_exited(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		shooting_left = false
		if !shooting_right:
			target = null

func _on_DetectionAreaRight_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		shooting_right = true
		if !target:
			target = body

func _on_DetectionAreaRight_body_exited(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		shooting_right = false
		if !shooting_left:
			target = null
		
func _on_Position_timeout():
	if !(!$Sprite.flip_h and shooting_right) and !($Sprite.flip_h and shooting_left):
		$Sprite.flip_h = !$Sprite.flip_h
		if $Sprite.flip_h:
			$Sprite.offset.x += 10
		else:
			$Sprite.offset.x -= 10
	$PositionTimer.start()

func _on_PlayerTimer_timeout():
	if player:
		player.explosion()
		player_timer.start()

func _on_HitArea_body_exited(body):
	if (body.is_in_group("programmer") or body.is_in_group("dron")) and player:
		player = null
