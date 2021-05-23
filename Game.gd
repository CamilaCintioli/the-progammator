extends Node

export (PackedScene) var turret_scene

onready var programmer = $Programmer
onready var dron = $Dron
onready var portal = $Portal
onready var codes = $Codes
onready var robot = $Robot
onready var movingFloor = $MovingFloor
onready var chrom = $Chrom
onready var interface = $Interface

var control = true
var is_game_over = false

func _ready():
	programmer.initialize(self)
	dron.initialize(self)
	portal.initialize(self)
	codes.initialize(self)
	robot.initialize(self)
	movingFloor.initialize(self)
	chrom.initialize($ChromEndPosition, self)
	$Robot2.initialize(self)
	$Robot3.initialize(self)
	$DialogBox.visible = false
	$Buttons/WhileButton.visible = false
	$Buttons/ForButton.visible = false
	$Buttons/IfButton.visible = false
	interface.initialize(self)
	start_turrets()
	
func start_turrets():
	var x_pos = $ChromEndPosition.global_position.x
	for i in [0,100,200,400,500,600,800,1000]:
		var turret = turret_scene.instance()
		turret.initialize(self, Vector2(x_pos - i, $ChromEndPosition.global_position.y))
	
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
	chrom.game_over()
	
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

func next_level():
	pass
	
func player_hit():
	interface.livesDecrease()
	print("leve1 player hit")
