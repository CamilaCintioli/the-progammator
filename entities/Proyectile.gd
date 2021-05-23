extends Area2D

onready var life_timer = $LifeTimer

export (float) var VELOCITY:float = 300.0

var container
var direction:Vector2
var is_player_projectile

func _ready():
	add_to_group("projectile")

func initialize(_container, spawn_position:Vector2, _direction:Vector2, _is_player_projectile):
	self.container = _container
	_container.add_child(self) 
	global_position = spawn_position
	self.direction = _direction
	self.is_player_projectile = _is_player_projectile
	life_timer.connect("timeout", self, "_on_life_timer_timeout")
	life_timer.start()

func _physics_process(delta):
	position += direction * VELOCITY * delta
	if is_player_projectile:
		$AnimationRam.play("ramroll")
	
func _remove():
	container.remove_child(self)
	queue_free()

func _on_life_timer_timeout():
	_remove()

func _on_Proyectile_body_entered(body):
	if (body.is_in_group("player") and !is_player_projectile) or body.is_in_group("programmer") or body.is_in_group("dron"):
		body.hit()
	if !body.is_in_group("robot") and !body.is_in_group("chrom") and !body.is_in_group("turret") and !is_player_projectile:
		call_deferred("_remove")
#	if body.is_in_group("chrom") and is_player_projectile:
#		print("chrome hit")
#		container.next_level()
