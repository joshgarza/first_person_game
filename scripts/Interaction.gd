class_name Interaction
extends Node

var player: CharacterBody3D
var camera: Camera3D

@export var max_distance: float = 2.5
@export var mask: int = 1 # set to match your interactables layer

var hovered: Node3D = null

func _process(_delta: float) -> void:
	if camera == null:
		return

	# Ray endpoints
	var from: Vector3 = camera.global_transform.origin
	var to: Vector3 = from + (-camera.global_transform.basis.z * max_distance)

	# Query + space
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = mask
	var space: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state

	# Raycast
	var hit: Dictionary = space.intersect_ray(query)

	# Resolve collider with types/cast
	hovered = null
	if not hit.is_empty():
		var node: Node3D = hit.get("collider") as Node3D
		if node and node.is_in_group("interactable"):
			hovered = node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and hovered and hovered.has_method("interact"):
		hovered.interact(player)
