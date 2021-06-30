extends ColorRect

export (PackedScene) var turret_scene

onready var sound = $Audio
onready var soundKey = $AudioStreamPlayer
onready var animEnter = $AnimationEnter
onready var animTitle = $AnimationTitle

var init_turrets = true
var container

func _ready():
	$Label.hide()
	sound.play()
	soundKey.play()
	animTitle.play("intro")
	yield(animTitle, "animation_finished")
	soundKey.stop()
	$Label.show()
	animEnter.play("blink")
	

func _process(_delta):
	if Input.is_action_pressed("start"):
		get_tree().change_scene("res://menu/PlayerMenu.tscn")
	if Input.is_action_pressed("one"):
		button_1()
	if Input.is_action_pressed("two"):
		button_2()
	if Input.is_action_pressed("three"):
		button_3()
	if Input.is_action_pressed("four"):
		button_4()
	if Input.is_action_pressed("five"):
		button_5()
	if Input.is_action_pressed("cero"):
		get_tree().change_scene("res://Game.tscn")

func initialize(_container):
	container = _container

func button_1():
	CheckpointsMenu.set_check(1)
	container.start_level_1()

func button_2():
	CheckpointsMenu.set_check(2)
	container.start_level_1()

func button_3():
	CheckpointsMenu.set_check(3)
	container.start_level_1()

func button_4():
	CheckpointsMenu.set_check(4)
	container.start_level_1()

func button_5():
	CheckpointsMenu.set_check(5)
	container.start_level_1()

func _on_Audio_finished():
	sound.play()



