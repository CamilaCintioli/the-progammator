extends Node

signal state_changed(current_state)

export (NodePath) var START_STATE
var states_map = {}

var states_stack = []
var current_state = null
var _active = false setget set_active

func set_parent(parent):
	if not START_STATE:
		START_STATE = get_child(0).get_path()
	for child in get_children():
		child.connect("finished", self, "_change_state")
		child.parent = parent
	initialize(START_STATE)

func initialize(start_state):
	set_active(true)
	states_stack.push_front(get_node(start_state))
	current_state = states_stack[0]
	current_state.enter()

func set_active(value):
	_active = value
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null

func _input(event):
	current_state.handle_input(event)

func _physics_process(delta):
	current_state.update(delta)

func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state._on_animation_finished(anim_name)

func _change_state(state_name):
	if not _active:
		return
	current_state.exit()
	
	states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	emit_signal("state_changed", current_state)
	
#	if state_name != "previous":
	current_state.enter()
