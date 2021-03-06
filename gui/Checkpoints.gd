extends Node2D

var check = 0
var programmer_position
var dron_position
var dron_enable = false
var is_check4 = 0
var container

func initialize(_container):
	container = _container

func _on_Checkpoint1_body_entered(body):
	if body.is_in_group("programmer"):
		check1()

func _on_Checkpoint2_body_entered(body):
	if body.is_in_group("programmer"):
		check2()

func _on_Checkpoint3_body_entered(body):
	if body.is_in_group("programmer"):
		check3()
		
func _on_Checkpoint32_body_entered(body):
	if body.is_in_group("programmer") or body.is_in_group("dron"):
		check32()

func _on_Checkpoint4_body_entered(body):
	if body.is_in_group("programmer"):
		check4()
		container.dron_bye2()
		container.start_turrets()
		container.chrom_start()

func check_4():
	is_check4 = 1

func _on_Checkpoint5_body_entered(body):
	if body.is_in_group("programmer"):
		check5()

func _on_Checkpoint6_body_entered(body):
	if body.is_in_group("programmer"):
		check6()

func check1():
	dron_enable = false
	check = 1
	programmer_position = $Checkpoint1/CollisionShape2D.global_position
	CheckpointsMenu.check = 1

func check2():
	dron_enable = true
	check = 2
	programmer_position = $Checkpoint2/CollisionShape2D.global_position
	dron_position = $DronStartPosition.global_position
	CheckpointsMenu.check = 2
	
func check3():
	dron_enable = true
	check = 3
	programmer_position = $Checkpoint3/CollisionShape2D.global_position
	dron_position = Vector2(programmer_position.x, programmer_position.y - 50)
	CheckpointsMenu.check = 3
	container.show_connection()
	
func check32():
	dron_enable = true
	check = 32
	programmer_position = $Checkpoint32/CollisionShape2D.global_position
	dron_position = Vector2(programmer_position.x, programmer_position.y - 50)
	CheckpointsMenu.check = 32
	
	container.show_connection()
	
func check4():
	dron_enable = false
	check = 4
	programmer_position = $Checkpoint4/CollisionShape2D.global_position
	container.interface.set_chrome_bar()
	CheckpointsMenu.check = 4
		
func check5():
	dron_enable = true
	check = 5
	programmer_position = $Checkpoint5/CollisionShape2D.global_position
	CheckpointsMenu.check = 5

func check6():
	dron_enable = true
	check = 6 
	programmer_position = $Checkpoint6/CollisionShape2D.global_position
	CheckpointsMenu.check = 6
	
	container.show_connection()

func checkpoint(nro):
	call("check" + str(nro))
