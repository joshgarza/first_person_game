extends MoveComponent

# Return the desired direction of movement for the character
# in the range [-1, 1], where positive values indicate a desire
# to move to the right and negative values to the left.
func get_movement_direction() -> Vector3:
	var direction: Vector3 = Vector3(0.0, 0.0, 0.0)

	if Input.is_action_pressed("move_forward"):
		direction += Vector3(0, 0, 1)
	if Input.is_action_pressed("move_back"):
		direction -= Vector3(0, 0, 1)
	if Input.is_action_pressed("move_left"):
		direction += Vector3(1, 0, 0)
	if Input.is_action_pressed("move_right"):
		direction -= Vector3(1, 0, 0)

	return direction

# Return a boolean indicating if the character wants to jump
func wants_jump() -> bool:
	return Input.is_action_just_pressed('jump')
