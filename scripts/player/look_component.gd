extends Node
class_name LookComponent

var player: CharacterBody3D
var camera: Camera3D

var _pitch_rad: float = 0.0
var _enabled: bool = true

@export var mouse_sensitivity_yaw: float = 0.001
@export var mouse_sensitivity_pitch: float = 0.001
@export var pitch_min_deg: float = -85.0
@export var pitch_max_deg: float = 85.0
@export var smooth_factor: float = 0.0  # 0 = off, 0.1..0.2 = light smoothing

var _target_pitch_rad: float = 0.0  # for smoothing

func init(p: CharacterBody3D, c: Camera3D) -> void:
	player = p
	camera = c
	_pitch_rad = camera.rotation.x
	_target_pitch_rad = _pitch_rad

func set_enabled(v: bool) -> void:
	_enabled = v

func apply_look_delta(delta: Vector2) -> void:
	if not _enabled or player == null or camera == null:
		return
	# Yaw (left/right) on the body
	player.rotate_y(-delta.x * mouse_sensitivity_yaw)

	# Pitch (up/down) on the camera pivot, clamped
	var min_rad := deg_to_rad(pitch_min_deg)
	var max_rad := deg_to_rad(pitch_max_deg)
	_target_pitch_rad = clamp(
		_target_pitch_rad - delta.y * mouse_sensitivity_pitch,
		min_rad, max_rad
	)

func _input(event: InputEvent) -> void:
	# Guard against early input before init()
	if player == null or camera == null:
		return
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		apply_look_delta(event.relative)

func _process(dt: float) -> void:
	if not _enabled or camera == null:
		return
	if smooth_factor > 0.0:
		_pitch_rad = lerp(_pitch_rad, _target_pitch_rad, clamp(dt / smooth_factor, 0.0, 1.0))
	else:
		_pitch_rad = _target_pitch_rad
	camera.rotation.x = _pitch_rad
