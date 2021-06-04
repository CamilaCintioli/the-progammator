extends KinematicBody2D

onready var life_timer = $LifeTimer

export (float) var VELOCITY:float = 300.0
export (int) var gravity:float = 300.0

var container
var direction
var velocity = Vector2.ZERO

func _ready():
	add_to_group("end_enemy_projectile")
	direction = randi() % 2
	if direction == 0:
		direction = -1

func initialize(_container, spawn_position:Vector2):
	self.container = _container
	_container.add_child(self) 
	global_position = spawn_position
	life_timer.connect("timeout", self, "_on_life_timer_timeout")
	life_timer.start()

func _physics_process(delta):
	velocity.y += gravity * delta
	if is_on_floor():
		velocity.x += direction
	else:
		velocity.x = lerp(velocity.x, 0, 0.1) if abs(velocity.x) > 1 else 0
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _remove():
	set_physics_process(false)
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	hide()
#	set_physics_process(false)
#	container.remove_child(self)
#	queue_free()

func _on_life_timer_timeout():
	_remove()

func bye():
	_remove()

func _on_Area2D_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		body.hit()
