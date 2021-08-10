extends CanvasLayer

signal exit_requested()
signal drone_controls()

onready var menu = $Control
onready var input_timer = $InputTimer
onready var programmer = $ProgrammerMenu
onready var drone = $DroneMenu

var can_pause:bool = false
var player:bool = false
var container

func _ready():
	menu.hide()
	programmer.hide()
	drone.hide()

func initialize(_container):
	can_pause = true
	container = _container

func exit_game():
	get_tree().quit()

func _unhandled_input(_event):
	if !container.is_game_over && can_pause && Input.is_action_just_pressed("start") && input_timer.is_stopped():
		if player:
			player = false
			emit_signal("drone_controls")
		else:
			drone.hide()
			var is_visible = menu.visible
			menu.visible = !is_visible
			get_tree().paused = !is_visible
			input_timer.start()

func _on_Continue_button_up():
	menu.hide()
	get_tree().paused = false

func _on_Exit_button_up():
	menu.hide()
	get_tree().paused = false
	emit_signal("exit_requested")

func _on_PauseMenu_exit_requested():
	get_tree().quit()

func _on_Controls_button_up():
	menu.hide()
	programmer.show()
	player = true

func _on_PauseMenu_drone_controls():
	programmer.hide()
	drone.show()
