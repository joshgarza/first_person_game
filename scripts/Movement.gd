class_name Movement
extends Node

var player: CharacterBody3D
var camera: Camera3D

@export var speed: float = 4.2
@export var acceleration: float = 20.0
@export var air_acceleration: float = 0.0
@export var friction: float = 10.0
@export var gravity: float = 9.8

# Jumping variables
@export var max_jump_hold_time: float = 0.3  # seconds
@export var jump_boost: float = 5.0         # upward acceleration while holding
@export var jump_velocity: float = 4.5

@export var mouse_sensitivity: float = 0.0001

var is_jumping: bool = false
var jump_time: float = 0.0
var airborne: bool = false
var look_vertical: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * mouse_sensitivity)
		look_vertical = clamp(look_vertical - event.relative.y * mouse_sensitivity, -PI/2, PI/2)
		camera.rotation.x = look_vertical
		
func get_input_direction() -> Vector3:
	var direction: Vector3 = Vector3.ZERO
	var cam_xform: Basis = player.global_transform.basis

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

func _physics_process(delta: float) -> void:
	# Check if jump was just pressed (start jump)
	if player.is_on_floor() and Input.is_action_just_pressed("jump"):
		player.velocity.y = jump_velocity
		is_jumping = true
		jump_time = 0.0

	# If jump is being held and we're mid-air and in boost window
	if is_jumping and not player.is_on_floor() and Input.is_action_pressed("jump"):
		if jump_time < max_jump_hold_time:
			player.velocity.y += jump_boost * delta
			jump_time += delta

	# Stop applying boost if jump released or boost window passed
	if Input.is_action_just_released("jump") or jump_time >= max_jump_hold_time:
		is_jumping = false

	# Apply gravity
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta

	# Horizontal movement
	var accel: float = acceleration if player.is_on_floor() else 0.0
	var input_dir: Vector3 = get_input_direction()
	var desired_velocity: Vector3 = input_dir * speed if player.is_on_floor() else Vector3(player.velocity.x, 0, player.velocity.z)

	player.velocity.x = move_toward(player.velocity.x, desired_velocity.x, accel * delta)
	player.velocity.z = move_toward(player.velocity.z, desired_velocity.z, accel * delta)

	# Friction
	if player.is_on_floor() and input_dir == Vector3.ZERO:
		player.velocity.x = move_toward(player.velocity.x, 0, friction * delta)
		player.velocity.z = move_toward(player.velocity.z, 0, friction * delta)

	player.move_and_slide()
