extends Node

onready var player = $Programmer
onready var dron = $Dron
onready var portal = $Portal
var control = true

func _ready():
	player.initialize(self)
	dron.initialize(self)
	portal.initialize(self)
	$DialogBox.visible = false
	
func change_control():
	control = !control
	if control:
		$Programmer/CameraProgramer.current = true
	else:
		$Dron/CameraDron.current = true

func hide_dialog():
	$DialogBox.visible = false

func show_dialog():
	$DialogBox.visible = true
