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
onready var upCamera = $UpCamera
onready var checkpoints = $Checkpoints

var init_end_camera
var control = true
var is_game_over = false
var end_game = false
var dron_zone = false
var change_zone = true
var change = true

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
	$Robot4.initialize(self)
	$DialogBox.visible = false
	interface.initialize(self)
	init_end_camera = endCamera.global_position
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

func hide_dialog():
	$DialogBox.visible = false

func show_dialog():
	$DialogBox.visible = true
		
func livesDecrease():
	interface.livesDecrease()
	
func dead():
	is_game_over = true
	interface.game_over()
	
func game_over():
	is_game_over = true
	programmer.set_game_over()
	dron.bye()
	
func dron_bye():
	change_control()
	end_game = true
	dron.bye()
	
func you_win():
	interface.you_win()

func restart():
	if checkpoints.check > 1:
		programmer.global_position = checkpoints.programmer_position
		programmer.set_physics_process(true)
		programmer.show()
		control = true
		is_game_over = false
		interface.set_on()
		programmer.velocity = Vector2.ZERO
		if checkpoints.dron_enable:
			dron.set_game_on()
			dron.global_position = checkpoints.dron_position
		if checkpoints.check == 2:
			upCamera.current = true
			upCamera.set_process(true)
			upCamera.global_position.y = checkpoints.programmer_position.y
			control = false
			dron_zone = true
			change_zone = false
		if checkpoints.check == 3:
			control = false
			$Dron/CameraDron.current = true
		if checkpoints.check == 5:
			$Programmer/CameraProgramer.current = true
			endCamera.global_position = init_end_camera
			control = true
	else:
		get_tree().reload_current_scene()
	
func change_platforms():
	if change:
		$ChangePlatform/Yellow.disable()
		$ChangePlatform/Green.enable()
	else:
		$ChangePlatform/Yellow.enable()
		$ChangePlatform/Green.disable()
	change = !change

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

func _on_DronUp_body_entered(body):
	if body.is_in_group("programmer"):
		dron_zone = true
		change_zone = false
		control = !control

func _on_Device_body_entered(body):
	if body.is_in_group("programmer"):
		dron_zone = false

func _on_ChangeCamera_body_entered(body):
	if body.is_in_group("dron"):
		checkpoints.check3()
		$Dron/CameraDron.current = true
		programmer.update_position($ChangePlatform/ProgrammerPosition.global_position)
		upCamera.stop()

func _on_StartUpCamera_body_entered(body):
	if body.is_in_group("programmer"):
		upCamera.start()

func _on_DeadArea_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		dead()
