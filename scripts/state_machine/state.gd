class_name State
extends Node

@export
var animation_name: String
@export
var walk_speed: float = 10
@export 
var mouse_sensitivity: float = 0.1
@export var speed: float = 4.2
@export var air_acceleration: float = 0.0

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")

var animations: AnimationPlayer
var move_component: MoveComponent
var parent: CharacterBody3D

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func get_movement_input() -> Vector3:
	var direction: Vector3 = move_component.get_movement_direction(parent)
	return direction

func get_jump() -> bool:
	return move_component.wants_jump()
