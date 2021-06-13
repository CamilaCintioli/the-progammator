extends Node2D

onready var raycast:RayCast2D = $CannonRaycast
onready var timer = $FiringTimer

export (float) var laser_range = 500
export (int) var damage = 1

var did_collide:bool = false

func _ready():
	raycast.cast_to.x = laser_range

func fire()->Vector2:
	raycast.force_raycast_update()
	did_collide = raycast.is_colliding()
	if did_collide:
		var collider = raycast.get_collider()
		print(collider.name)
		if collider.has_method("notify_hit"):
			collider.notify_hit(damage)
#			timer.start()
		return raycast.get_collision_point()
	else:
		return raycast.to_global(raycast.cast_to)

func add_collision_exception_to_projectile(object):
	raycast.add_exception(object)
