extends Node

func _ready():
	$Menu.initialize(self)

func start_level_1():
	get_tree().change_scene("res://Game.tscn")
