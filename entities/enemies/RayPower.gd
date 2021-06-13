extends Node2D

onready var ray_texture = $Ray

func clamp_distance(distance):
	ray_texture.scale.y = (distance - ray_texture.position.x) / 64.0
