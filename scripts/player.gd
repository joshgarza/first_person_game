extends CharacterBody3D

@export var speed := 5.0
@export var acceleration := 20.0
@export var air_acceleration := 0.0
@export var friction := 10.0
@export var gravity := 9.8

# Jumping variables
@export var max_jump_hold_time := 0.3  # seconds
@export var jump_boost := 5.0         # upward acceleration while holding
@export var jump_velocity := 4.5

@export var mouse_sensitivity := 0.002

var is_jumping := false
var jump_time := 0.0
var airborne := false
var look_vertical := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		look_vertical = clamp(look_vertical - event.relative.y * mouse_sensitivity, -PI/2, PI/2)
		$Camera3D.rotation.x = look_vertical
		
func get_input_direction() -> Vector3:
	var direction = Vector3.ZERO
	var cam_xform = global_transform.basis

	if Input.is_action_pressed("move_forward"):
		direction -= cam_xform.z
	if Input.is_action_pressed("move_back"):
		direction += cam_xform.z
	if Input.is_action_pressed("move_left"):
		direction -= cam_xform.x
	if Input.is_action_pressed("move_right"):
		direction += cam_xform.x

	direction.y = 0
	return direction.normalized()

func _physics_process(delta):
	# Check if jump was just pressed (start jump)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		is_jumping = true
		jump_time = 0.0

	# If jump is being held and we're mid-air and in boost window
	if is_jumping and not is_on_floor() and Input.is_action_pressed("jump"):
		if jump_time < max_jump_hold_time:
			velocity.y += jump_boost * delta
			jump_time += delta

	# Stop applying boost if jump released or boost window passed
	if Input.is_action_just_released("jump") or jump_time >= max_jump_hold_time:
		is_jumping = false

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Horizontal movement
	var accel = acceleration if is_on_floor() else 0.0
	var input_dir = get_input_direction()
	var desired_velocity = input_dir * speed if is_on_floor() else Vector3(velocity.x, 0, velocity.z)

	velocity.x = move_toward(velocity.x, desired_velocity.x, accel * delta)
	velocity.z = move_toward(velocity.z, desired_velocity.z, accel * delta)

	# Friction
	if is_on_floor() and input_dir == Vector3.ZERO:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	move_and_slide()
