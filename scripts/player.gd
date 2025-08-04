extends CharacterBody3D

@export var speed := 5.0
@export var mouse_sensitivity := 0.002
@export var gravity := 9.8

var look_vertical := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		look_vertical = clamp(look_vertical - event.relative.y * mouse_sensitivity, -PI/2, PI/2)
		$Camera3D.rotation.x = look_vertical

func _physics_process(delta):
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
	direction = direction.normalized()

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	# Apply movement
	var horizontal_velocity = direction * speed
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	move_and_slide()
