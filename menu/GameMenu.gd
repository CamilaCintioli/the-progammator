extends CanvasLayer

signal exit_requested()
signal show_controls()

onready var menu = $Control
onready var input_timer = $InputTimer

var can_pause:bool = false

func _ready():
	menu.hide()
	call_deferred("initialize")

func initialize():
	can_pause = true

func exit_game():
	get_tree().quit()

func _unhandled_input(_event):
	if can_pause && Input.is_action_just_pressed("start") && input_timer.is_stopped():
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
	emit_signal("show_controls")

func _on_PauseMenu_show_controls():
	pass # Replace with function body.
