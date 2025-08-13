extends State

@export
var walk_state: State
@export
var jump_state: State

func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO

func process_input(event: InputEvent) -> State:
	if get_jump():
		return jump_state
	if get_movement_input() != Vector3.ZERO:
		return walk_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta
	parent.move_and_slide()
	#
	#if !parent.is_on_floor():
		#return fall_state
	return null
