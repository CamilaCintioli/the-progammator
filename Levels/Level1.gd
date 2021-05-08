extends Node

onready var player = $Player

export (PackedScene) var matrix_turret_scene

func _ready():
	player.initialize(self)
	for i in [35,105,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500]:
		var turret = matrix_turret_scene.instance()
		turret.initialize(self, Vector2(i, 0))
