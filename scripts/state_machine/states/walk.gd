extends State

@export
var idle_state: State

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	var movement: Vector3 = get_movement_input() * walk_speed
	
	if movement == Vector3.ZERO:
		return idle_state

	parent.velocity = movement
	parent.move_and_slide()
	
	return null
