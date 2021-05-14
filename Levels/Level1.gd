extends Node

onready var player = $Player
onready var interface = $Interface

export (PackedScene) var matrix_turret_scene

func _ready():
	interface.initialize(self)
	player.initialize(self)
	for i in [35,105,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500]:
		var turret = matrix_turret_scene.instance()
		turret.initialize(self, Vector2(i, 0))

func next_level():
	get_tree().change_scene("res://Levels/Level2.tscn")
	
func player_hit():
	interface.livesDecrease()
	print("leve1 player hit")

func game_over():
	player.set_game_over()
	$Chrom.game_over()
	
func restart():
	get_tree().reload_current_scene()
	
	
