extends Node

export (PackedScene) var turret_scene

onready var programmer = $Programmer
onready var dron = $Dron
onready var portal = $Portal
onready var bugs = $Bugs
onready var robot = $Robot
onready var movingFloor = $MovingFloor
onready var chrom = $Chrom
onready var interface = $Interface
onready var endCamera = $EndCamera

signal stop_shooting

var control = true
var is_game_over = false
var end_game = false

func _ready():
	programmer.initialize(self)
	dron.initialize(self)
	portal.initialize(self)
	bugs.initialize(self)
	robot.initialize(self)
	movingFloor.initialize(self)
	chrom.initialize($ChromEndPosition, self)
	endCamera.initialize(programmer)
	$Robot2.initialize(self)
	$Robot3.initialize(self)
	$DialogBox.visible = false
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

func in_end_game():
	end_game = true
	dron.bye()

func hide_dialog():
	$DialogBox.visible = false

func show_dialog():
	$DialogBox.visible = true
		
func livesDecrease():
	interface.livesDecrease()
	
func chrom_hit():
	interface.chrom_hit()
	
func chrom_finished():
	emit_signal("stop_shooting")
	chrom.game_over()
	
func dead():
	is_game_over = true
	interface.game_over()
	
func game_over():
	is_game_over = true
	programmer.set_game_over()
	dron.bye()
	chrom.game_over()
	
func dron_bye():
	dron.bye()
	
func you_win():
	interface.you_win()
	
func restart():
	get_tree().reload_current_scene()

func _on_ForButton_pressed():
	$DialogBox/Solution.text = "wrong answer"

func _on_WhileButton_pressed():
	$DialogBox.visible = false
	$Bugs/BugsInfo/Label.text = ""
	portal.bye()
	
func _on_IfButton_pressed():
	$DialogBox/Solution.text = "wrong answer"

func _on_Cooler_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		dead()
		game_over()

func _on_Cooler2_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		dead()
		game_over()

func _on_Cooler3_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		dead()
		game_over()

func _on_Cooler4_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		dead()
		game_over()

func there_are_bugs() -> int:
	return $Bugs.bugs > 0
	
func bye_portal():
	$Portal.bye()

func _on_Area2D_body_entered(body):
	if body.is_in_group("programmer"):
		$Info.show()

func _on_Area2D_body_exited(body):
	if body.is_in_group("programmer"):
		$Info.hide()

func _on_EndArea_body_entered(body):
	if body.is_in_group("programmer") and !endCamera.current:
		endCamera.current = true
		endCamera.set_process(true)
		in_end_game()
