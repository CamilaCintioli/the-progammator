extends Node

onready var player = $Programmer
onready var dron = $Dron
var control = true

func _ready():
	player.initialize(self)
	dron.initialize(self)
	
func change_control():
	control = !control
