extends Node

onready var player = $Programmer
onready var dron = $Dron
onready var portal = $Portal
onready var while_code = $While
onready var dialog = $DialogBox

var control = true

func _ready():
	player.initialize(self)
	dron.initialize(self)
	portal.initialize(self)
	dialog.initialize(self)
	while_code.initialize(self, dron, while_code.global_position)
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
	
func release():
	while_code.release()
	
func bye_portal():
	portal.bye()
	dialog.bye()
	while_code.bye()
