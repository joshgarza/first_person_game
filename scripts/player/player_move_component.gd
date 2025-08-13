extends MoveComponent

# Return the desired direction of movement for the character
# in the range [-1, 1], where positive values indicate a desire
# to move to the right and negative values to the left.
func get_movement_direction(actor: CharacterBody3D) -> Vector3:
	var direction: Vector3 = Vector3.ZERO
	var cam_xform: Basis = actor.global_transform.basis

	if Input.is_action_pressed("move_forward"):
		direction += cam_xform.z
	if Input.is_action_pressed("move_back"):
		direction -= cam_xform.z
	if Input.is_action_pressed("move_left"):
		direction += cam_xform.x
	if Input.is_action_pressed("move_right"):
		direction -= cam_xform.x

	return direction.normalized()

# Return a boolean indicating if the character wants to jump
func wants_jump() -> bool:
	return Input.is_action_just_pressed('jump')
