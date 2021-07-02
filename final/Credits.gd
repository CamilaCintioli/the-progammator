extends Sprite

var pos = 0
var initial_x

func _ready():
	initial_x = global_position.x + 0

func _physics_process(_delta):
	global_position.x -= 2
	if Input.is_action_pressed("start"):
		get_tree().change_scene("res://Game.tscn")
	if global_position.x < -2400:
		global_position.x = initial_x
