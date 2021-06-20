extends "res://entities/player/StateMachine.gd"

enum STATES {
	IDLE,
	WALK,
	JUMP,
	DEAD,
	RUN
}

var animations_map:Dictionary = {
	STATES.IDLE: "idle",
	STATES.WALK: "walk",
	STATES.JUMP: "jump",
	STATES.DEAD: "dead"
}

func initialize(parent):
	.initialize(parent)
	call_deferred("set_state", STATES.IDLE)

func _state_logic(_delta):
	parent._handle_actions()

	if parent.container.control && ![STATES.IDLE, STATES.DEAD].has(state):
		parent._handle_move_input()
	
	if parent.container.control && state == STATES.JUMP && Input.is_action_just_pressed("jump") && parent.jumps < 1:
		parent.snap_vector = Vector2.ZERO
		parent.velocity.y = -parent.jump_speed
		parent.jumps += 1
		parent._play_animation(animations_map[state])
	
	if parent.container.control && state == STATES.RUN || (state == STATES.JUMP && Input.is_action_pressed("run")):
		parent._handle_acceleration(2)
	else:
		parent._handle_acceleration()
	parent._apply_movement()

func _get_transition(_delta):
	if !parent.container.control:
		return STATES.IDLE
	if state != STATES.DEAD && parent.container.interface.heartNum == 0:
		parent._remove()
		return STATES.DEAD
	if Input.is_action_just_pressed("jump") && [STATES.IDLE, STATES.WALK, STATES.RUN].has(state) && (parent.is_on_floor() || parent.jumps < 1):
		parent.snap_vector = Vector2.ZERO
		parent.velocity.y = -parent.jump_speed
		parent.jumps += 1 * (1 + int(!parent.is_on_floor()))
		return STATES.JUMP
	
	match state:
		STATES.IDLE:
			if int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")) != 0:
				if Input.is_action_pressed("run"):
					return STATES.RUN
				else:
					return STATES.WALK
		STATES.WALK:
			if parent.move_direction == 0:
				return STATES.IDLE
			elif Input.is_action_pressed("run"):
				return STATES.RUN
		STATES.RUN:
			if !Input.is_action_pressed("run"):
				if parent.move_direction == 0:
					return STATES.IDLE
				else:
					return STATES.WALK
		STATES.JUMP:
			if parent.is_on_floor():
				parent.jumps = 0
				if parent.move_direction != 0:
					return STATES.WALK
				else:
					return STATES.IDLE
	return null

func _enter_state(new_state, _old_state):
	if [STATES.RUN, STATES.WALK].has(new_state):
		parent._play_animation(animations_map[STATES.WALK], false, 2.0 if state == STATES.RUN else 1.0)
	else:
		parent._play_animation(animations_map[new_state])

func _exit_state(_old_state, _new_state):
	pass

func handle_fatal_hit():
	pass
