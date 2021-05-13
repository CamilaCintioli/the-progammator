extends Node

onready var player = $Programmer
onready var dron = $Dron
onready var portal = $Portal
onready var codes = $Codes
var control = true

func _ready():
	player.initialize(self)
	dron.initialize(self)
	portal.initialize(self)
	codes.initialize(self)
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
