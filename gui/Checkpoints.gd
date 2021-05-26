extends Node2D

var check = 0
var programmer_position
var dron_position
var dron_enable = false
var check4 = 0

func _on_Checkpoint1_body_entered(body):
	if body.is_in_group("programmer"):
		dron_enable = false
		check = 1
		programmer_position = $Checkpoint1/CollisionShape2D.global_position

func _on_Checkpoint2_body_entered(body):
	if body.is_in_group("programmer"):
		dron_enable = true
		check = 2
		programmer_position = $Checkpoint2/CollisionShape2D.global_position
		dron_position = $DronStartPosition.global_position

func _on_Checkpoint3_body_entered(body):
	if body.is_in_group("programmer"):
		dron_enable = true
		check = 3
		programmer_position = $Checkpoint3/CollisionShape2D.global_position
		dron_position = Vector2(programmer_position.x, programmer_position.y - 50)

func _on_Checkpoint4_body_entered(body):
	if body.is_in_group("programmer"):
		dron_enable = true
		check = 4
		programmer_position = $Checkpoint4/CollisionShape2D.global_position
		dron_position = Vector2(programmer_position.x, programmer_position.y - 50)
		if check4 == 1:
			dron_enable = false
			
func check_4():
	check4 = 1

func _on_Checkpoint5_body_entered(body):
	if body.is_in_group("programmer"):
		dron_enable = false
		check = 5
		programmer_position = $Checkpoint5/CollisionShape2D.global_position
		
func check3():
	dron_enable = true
	check = 3
	programmer_position = $Checkpoint3/CollisionShape2D.global_position
	dron_position = Vector2(programmer_position.x, programmer_position.y - 50)
