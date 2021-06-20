extends ColorRect

export (PackedScene) var turret_scene

onready var sound = $Audio

var init_turrets = true
var container

func _ready():
	sound.play()

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
	start_turrets()

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

func start_turrets():
	if init_turrets:
		init_turrets = false
		for pos in [0,50,100,150,200,250,300,400,500,600,700,750,800,850,900,950,1000,1050,1100,1150,1200,1300]:
			var turret = turret_scene.instance()
			turret.initialize(self, Vector2(pos, 0))

func _on_Audio_finished():
	sound.play()
