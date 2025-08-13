extends State

@export var idle_state: State
@export var walk_state: State
@export var fall_state: State

@export var max_jump_hold_time := 1.3
@export var jump_boost := 5.0
@export var jump_velocity := 3

var _jump_time := 0.0
var _boosting := false
var _since_enter := 0.0
var _saved_snap := 0.0

func enter() -> void:
	super()
	_saved_snap = parent.floor_snap_length
	#parent.floor_snap_length = 0.0               # prevent ground glue
	if parent.is_on_floor():
		parent.velocity.y = jump_velocity
	_boosting = true
	_jump_time = 0.0
	_since_enter = 0.0

func process_physics(dt: float) -> State:
	_since_enter += dt

	## Hold-to-jump-height (boost) window
	#if _boosting and Input.is_action_pressed("jump") and _jump_time < max_jump_hold_time:
		#parent.velocity.y += jump_boost * dt
		#_jump_time += dt
	#else:
		#_boosting = false

	# Gravity
	if not parent.is_on_floor():
		parent.velocity.y -= gravity * dt

	# In-air horizontal control
	var dir := get_movement_input()
	var desired := dir * speed
	parent.velocity.x = move_toward(parent.velocity.x, desired.x, air_acceleration * dt)
	parent.velocity.z = move_toward(parent.velocity.z, desired.z, air_acceleration * dt)

	parent.move_and_slide()

	# Landing (after move_and_slide)
	if parent.is_on_floor() and parent.velocity.y <= 0.0:
		parent.floor_snap_length = _saved_snap
		return idle_state if dir == Vector3.ZERO else walk_state

	# Transition to fall after apex, with a small hysteresis to avoid “early fall”
	if parent.velocity.y <= 0.0 and _since_enter > 0.02:  # ~1–2 physics frames
		return fall_state

	return null

func exit() -> void:
	parent.floor_snap_length = _saved_snap
