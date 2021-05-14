extends Node

onready var player = $Programmer
onready var dron = $Dron
onready var portal = $Portal
onready var codes = $Codes
onready var robot = $Robot
var control = true

func _ready():
	player.initialize(self)
	dron.initialize(self)
	portal.initialize(self)
	codes.initialize(self)
	robot.initialize(self)
	$DialogBox.visible = false
	
func change_control():
	control = !control
	if control:
		$Programmer/CameraProgramer.current = true
	else:
		$Dron/CameraDron.current = true

func hide_dialog():
	$DialogBox.visible = false
	for c in $Codes.codes:
		show_button(c, false)

func show_dialog():
	$DialogBox.visible = true
	for c in $Codes.codes:
		show_button(c, true)
	
func show_button(code, visible):
	if code == 'while':
		$Buttons/WhileButton.visible = visible
	if code == 'if':
		$Buttons/IfButton.visible = visible
	if code == 'for':
		$Buttons/ForButton.visible = visible

func _on_ForButton_pressed():
	pass

func _on_WhileButton_pressed():
	$Buttons/WhileButton.visible = false
	$Buttons/ForButton.visible = false
	$Buttons/IfButton.visible = false
	$DialogBox.visible = false
	$Codes/CodesInfo/Label.text = ""
	portal.bye()

func _on_IfButton_pressed():
	pass
	
func bye():
	robot.target = null
