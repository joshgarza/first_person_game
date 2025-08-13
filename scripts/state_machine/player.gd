class_name Player
extends CharacterBody3D

@onready
var camera: Camera3D = $Camera3D
@onready
var movement_animations: AnimationPlayer = $movement_animations
@onready
var movement_state_machine: Node = $movement_state_machine
@onready
var player_move_component: MoveComponent = $player_move_component
@onready
var look: LookComponent = $look_component

func _ready() -> void:
	movement_state_machine.init(self, movement_animations, player_move_component)
	look.init(self, camera)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	movement_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	movement_state_machine.process_frame(delta)
