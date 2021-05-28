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
		
func check1():
	dron_enable = false
	check = 1
	programmer_position = $Checkpoint1/CollisionShape2D.global_position

func check2():
	dron_enable = true
	check = 2
	programmer_position = $Checkpoint2/CollisionShape2D.global_position
	dron_position = $DronStartPosition.global_position
	
func check3():
	dron_enable = true
	check = 3
	programmer_position = $Checkpoint3/CollisionShape2D.global_position
	dron_position = Vector2(programmer_position.x, programmer_position.y - 50)
	
func check4():
	dron_enable = false
	check = 4
	programmer_position = $Checkpoint4/CollisionShape2D.global_position
		
func check5():
	dron_enable = false
	check = 5
	programmer_position = $Checkpoint5/CollisionShape2D.global_position
	
func checkpoint(nro):
	call("check" + str(nro))
