extends Node

onready var menu = $Menu

func _ready():
	call_deferred("initialize")

func initialize():
	menu.can_pause = true

func exit_game():
	get_tree().quit()
