extends State

@export var idle_state: State
@export var walk_state: State

var _saved_snap := 0.0

func enter() -> void:
	super()
	_saved_snap = parent.floor_snap_length
	parent.floor_snap_length = 0.0   # keep snap off while airborne

func process_physics(dt: float) -> State:
	# Gravity
	parent.velocity.y -= gravity * dt

	# In-air horizontal control
	var dir := get_movement_input()
	var desired := dir * speed
	parent.velocity.x = move_toward(parent.velocity.x, desired.x, air_acceleration * dt)
	parent.velocity.z = move_toward(parent.velocity.z, desired.z, air_acceleration * dt)

	parent.move_and_slide()

	# Landed? decide idle vs walk AFTER move
	if parent.is_on_floor() and parent.velocity.y <= 0.0:
		parent.floor_snap_length = _saved_snap
		return idle_state if dir == Vector3.ZERO else walk_state

	return null

func exit() -> void:
	parent.floor_snap_length = _saved_snap
