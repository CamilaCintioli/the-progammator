extends Node

onready var programmer = $Programmer
onready var dron = $Dron
onready var portal = $Portal
onready var codes = $Codes
onready var robot = $Robot
onready var movingFloor = $MovingFloor

export (PackedScene) var interface_scene:PackedScene
export (PackedScene) var matrix_turret_scene:PackedScene

var control = true
var is_game_over = false
var interface

func _ready():
	programmer.initialize(self)
	dron.initialize(self)
	portal.initialize(self)
	codes.initialize(self)
	robot.initialize(self)
	movingFloor.initialize(self)
	$Robot2.initialize(self)
	$Robot3.initialize(self)
	$DialogBox.visible = false
	$Buttons/WhileButton.visible = false
	$Buttons/ForButton.visible = false
	$Buttons/IfButton.visible = false
	interface = interface_scene.instance()
	add_child(interface)
	interface.initialize(self)
	
func change_control():
	control = !control
	if control:
		$Programmer/CameraProgramer.current = true
	else:
		$Dron/CameraDron.current = true

func hide_dialog():
	$DialogBox/Solution.visible = false
	$DialogBox.visible = false
	for c in $Codes.codes:
		show_button(c, false)

func show_dialog():
	$DialogBox/Solution.visible = true
	$DialogBox/Solution.text = "Choose the right option"
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
		
func livesDecrease():
	interface.livesDecrease()
	
func game_over():
	is_game_over = true
	programmer.set_game_over()
	dron.set_game_over()
	interface.heartNum = 0
	interface.game_over()
	
func you_win():
	interface.you_win()
	
func restart():
	get_tree().reload_current_scene()

func _on_ForButton_pressed():
	$DialogBox/Solution.text = "wrong answer"

func _on_WhileButton_pressed():
	$Buttons/WhileButton.visible = false
	$Buttons/ForButton.visible = false
	$Buttons/IfButton.visible = false
	$DialogBox/Solution.visible = false
	$DialogBox.visible = false
	$Codes/CodesInfo/Label.text = ""
	portal.bye()
	var x_pos = $MovingFloor/EndPosition.global_position.x
	for i in [0,100,200,400,500,600,800,1000,1100,1300]:
		var turret = matrix_turret_scene.instance()
		turret.initialize(self, Vector2(x_pos + i, 40))

func _on_IfButton_pressed():
	$DialogBox/Solution.text = "wrong answer"

func _on_Cooler_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		game_over()

func _on_Cooler2_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		game_over()

func _on_Cooler3_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		game_over()

func _on_Cooler4_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		game_over()
