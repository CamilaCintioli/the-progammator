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
onready var endEnemy = $EndEnemy
onready var coffee = $Coffee
onready var audio_stream = $AudioStreamEffects
onready var cplus = $CPlus

signal stop_shooting

var init_end_camera
var control = true
var is_game_over = false
var end_game = false
var dron_zone = false
var change_zone = true
var change = true
var init_turrets = true
var chrom_dead = false
var final = true
var has_started = false
var can_change = false

func _ready():
	programmer.initialize(self)
	dron.initialize(self)
	portal.initialize(self)
	bugs.initialize(self)
	movingFloor.initialize(self)
	checkpoints.initialize(self)
	_initialize_coffee_health_packs()
	_initialize_robots()
	chrom.initialize($ChromEndPosition, self)
	endCamera.initialize(programmer)
	endEnemy.initialize(self)
	upCamera.initialize(self)
	$PauseMenu.initialize(self)
	$DialogBox.visible = false
	interface.initialize(self)
	init_end_camera = endCamera.global_position
	start_checkpoint(CheckpointsMenu.check)
	cplus.initialize(self)
	
	$BGMusicStreamPlayer.play()

func _initialize_coffee_health_packs():
	coffee.initialize(self, audio_stream)
	$Coffee2.initialize(self, audio_stream)
	$Coffee3.initialize(self, audio_stream)
	$Coffee4.initialize(self, audio_stream)
	$Coffee5.initialize(self, audio_stream)
	$Coffee6.initialize(self, audio_stream)
	$Coffee7.initialize(self, audio_stream)
	$Coffee8.initialize(self, audio_stream)
	$Coffee9.initialize(self, audio_stream)
	$Coffee10.initialize(self, audio_stream)
	
func _initialize_robots():
	robot.initialize(self)
	$Robot2.initialize(self)
	$Robot3.initialize(self)
	$Robot4.initialize(self)
	$Robot5.initialize(self)

func start_turrets():
	if init_turrets:
		init_turrets = false
		var x_pos = $ChromEndPosition.global_position.x
		for i in [0,100,200,300,400,500,600,700,800,900,1000]:
			var turret = turret_scene.instance()
			turret.initialize(self, Vector2(x_pos - i, $ChromEndPosition.global_position.y))
	
func start_checkpoint(nro):
	if nro > 0:
		checkpoints.checkpoint(nro)
		restart()

func change_control():
	control = !control
	if control || (!can_change):
		$Programmer/CameraProgramer.current = true
	else:
		$Dron/CameraDron.current = true

func enable_change(value):
	can_change = value

func show_connection():
	if(checkpoints.check == 3 ||
		checkpoints.check == 32 ||
		checkpoints.check == 6 ):
		interface.show_dron_connection(true)
	else:
		interface.show_dron_connection(false)

func in_end_game():
	end_game = true

func hide_dialog():
	$DialogBox.visible = false
	
func show_dialog():
	$DialogBox.visible = true
	
func livesDecrease():
	interface.livesDecrease(audio_stream)

func livesIncrease():
	interface.livesIncrease()

func chrom_hit():
	audio_stream.chrom_hit()
	interface.chrom_hit()
	
func chrom_finished():
	emit_signal("stop_shooting")
	interface.hide_chrome_bar()
	interface.show_ram(false)
	audio_stream.chrom_explosion()
	chrom.game_over()
	$BGs/bg3Animation.stop()
	$ChromPortal.bye(self)
#	$ChromPortalStart.bye(self)
	
func pc_finished():
	endEnemy.game_over()
	
func chrom_start():
	$ChromPortalStart.stop_collision()
	if !chrom_dead:
		chrom.start()
	
func dead():
	is_game_over = true
	interface.game_over(audio_stream)
	endEnemy.set_drone(false)
	endEnemy.game_over()
#	endEnemy.restart($EndEnemyPosition.global_position)
	
func game_over():
	is_game_over = true
	programmer.set_game_over()
	dron.bye()
	endEnemy.game_over()
	$BGMusicStreamPlayer.stream_paused = true
	
func dron_bye():
	change_control()
	end_game = true
	dron.bye()
	
func dron_bye2():
	end_game = true
	dron.end_position($DronEndPosition.global_position)
	dron.set_game_over()
	
func you_win():
	audio_stream.game_win()
	interface.you_win()
	
func restart_tree():
	get_tree().change_scene("res://Game.tscn")

func restart():
	interface.set_on()
	$BGMusicStreamPlayer.stream_paused = false
	if checkpoints.check > 0:
		programmer.global_position = checkpoints.programmer_position
		programmer.set_physics_process(true)
		programmer.show()
		control = true
		is_game_over = false
		programmer.velocity = Vector2.ZERO
		dron.restart()
		if checkpoints.dron_enable:
			dron.set_game_on()
			if checkpoints.dron_position:
				dron.global_position = checkpoints.dron_position
		if checkpoints.check == 1:
			dron.set_game_on()
			$Programmer/CameraProgramer.current = true
			upCamera.global_position.y = checkpoints.programmer_position.y
		if checkpoints.check == 2:
			upCamera.current = true
			upCamera.set_process(true)
			upCamera.global_position.y = checkpoints.programmer_position.y
			control = false
			dron_zone = true
			change_zone = false
			change = false
			$InfoDrone.visible = true
			$InfoDrone/InfoDroneText.visible = true
			interface.show_dron_connection(false)
		if checkpoints.check == 3 or checkpoints.check == 32:
			change_zone = false
			end_game = false
			control = false
			$Dron/CameraDron.current = true
			interface.show_dron_connection(true)
		if checkpoints.check == 4 or checkpoints.check == 5:
			$Programmer/CameraProgramer.current = true
			endCamera.global_position = init_end_camera
			control = true
			end_game = true
			dron_bye2()
			interface.show_dron_connection(false)
			if(checkpoints.check == 4):
				cplus.has_entered = true
				cplus.show_dialog(true)
				add_ram()
		if checkpoints.check == 5:
			end_game = false
			endEnemy.set_drone(false)
			endEnemy.restart($EndEnemyPosition.global_position)
			interface.show_dron_connection(false)
		if checkpoints.check == 6:
			end_game = false
			dron.global_position = $DronEndPosition.global_position
			interface.set_end_enemy_bar()
			interface.show_dron_connection(true)
			$EndGreenWall.set_on()
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
	
func dron_hit_end_enemy():
	interface.end_enemy_hit()
#	dron.hit_end_enemy()

func endEnemy_hit():
	interface.endEnemy_hit()

func _on_ForButton_pressed():
	#$DialogBox/Solution.text = "wrong answer"
	pass

func _on_WhileButton_pressed():
	#$DialogBox.visible = false
	$Bugs/BugsInfo/Label.text = ""
	portal.bye()
	
func _on_IfButton_pressed():
	#$DialogBox/Solution.text = "wrong answer"
	pass

func set_camera_player():
	$Programmer/CameraProgramer.current = true
	chrom_dead = true
	end_game = false

func there_are_bugs() -> int:
	return $Bugs.bugs > 0
	
func bye_portal():
	$Portal.bye()
	
func set_connection(conn_level):
	if(conn_level ==0):
		dron.set_game_over()
	interface.set_dron_connection(conn_level)
	

func _on_EndArea_body_entered(body):
	if body.is_in_group("programmer") and !endCamera.current:
		endCamera.current = true
		endCamera.set_process(true)
		in_end_game()
		endEnemy.start()
		interface.set_end_enemy_bar()
		end_game = false
		$EndGreenWall.stop_collision()

func _on_DronUp_body_entered(body):
	if body.is_in_group("programmer"):
		dron_zone = true
		change_zone = false
		control = false
		change = false
		$InfoDrone.visible = true
		$InfoDrone/InfoDroneText.visible = true

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
		upCamera.global_position.y = checkpoints.programmer_position.y
		upCamera.start()

func _on_DeadArea_body_entered(body):
	if body.is_in_group("programmer") and !is_game_over:
		dead()

func _on_Timer_timeout():
	change_platforms()
	if(! has_started):
		has_started = true
		$ChangePlatform/Green.play()
		$ChangePlatform/Yellow.play()

func _on_EndProgrammerArea_body_entered(body):
	if body.is_in_group("programmer"):
		$EndMovingPlatform.move()
		$EndGreenWall.set_on()
		endEnemy.to_end()
		
func _on_BGMusicStreamPlayer_finished():
	$BGMusicStreamPlayer.play()

func _on_ChromCameraStart_body_entered(body):
	if !chrom_dead and body.is_in_group("programmer"):
		$ChromCamera.current = true
		$ChromPortalStart.set_on()

func _on_EndProgrammerArea_body_exited(body):
	if body.is_in_group("programmer"):
		$EndMovingPlatform.stop()
		$EndEnemyCamera.current = true
		control = false
		endEnemy.set_drone(true)
		dron.come_back()
		endEnemy.restart_laser()
		#programmer.set_game_over()
		endEnemy.global_position = Vector2($DronEndPosition.global_position.x + 500, $DronEndPosition.global_position.y) 
		endEnemy.global_position = Vector2($DronEndPosition.global_position.x + 500, $DronEndPosition.global_position.y)

func bug_fixed():
	audio_stream.bug_fixed()

func play_robot_killed_sound():
	audio_stream.robot_killed()
	
func cel_audio():
	audio_stream.cel_audio()
	
func add_ram():
	interface.show_ram(true)

func _on_ChangeCamera_body_exited(body):
	if body.is_in_group("dron"):
		programmer.update_position($ChangePlatform/ProgrammerPosition.global_position)

func jump():
	audio_stream.jump()
