class_name Interaction
extends Node

@onready var player: CharacterBody3D = get_parent() as CharacterBody3D
@onready var camera: Camera3D = player.get_node("Head/Camera3D") as Camera3D
@onready var hands: Hands = player.get_node("Hands") as Node3D

@export var max_distance: float = 2.5
@export var mask: int = 1 # interactables layer

@export var drop_hold_threshold := 0.5 # seconds to hold F to drop

var hovered: Node3D = null
var ray: RayCast3D

# --- hold-to-drop state ---
var _interact_down := false
var _interact_time := 0.0
var _drop_fired := false

func _ready() -> void:
	assert(camera != null)
	ray = camera.get_node_or_null("InteractRay") as RayCast3D
	assert(ray != null)
	_configure_ray()

func _process(_dt: float) -> void:
	# Keep ray length in sync if you tweak max_distance in the editor
	var desired := Vector3(0, 0, -max_distance)
	if ray.target_position != desired:
		ray.target_position = desired

	# Hover resolution
	var new_hover: Node3D = null
	if ray.is_colliding():
		var collider := ray.get_collider() as Node
		new_hover = _find_interactable_root(collider)

	if new_hover != hovered:
		if hovered and hovered.has_method("on_hover_end"):
			hovered.on_hover_end()
		hovered = new_hover
		if hovered and hovered.has_method("on_hover_start"):
			hovered.on_hover_start()
			
	# hold-to-drop timer
	if _interact_down:
		_interact_time += _dt
		if not _drop_fired and _interact_time >= drop_hold_threshold and hands and hands.has_item():
			hands.drop_current()
			_drop_fired = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_interact_down = true
		_interact_time = 0.0
		_drop_fired = false

	elif event.is_action_released("interact"):
		# If we released before threshold, treat as a tap (pickup/use)
		if not _drop_fired:
			if hovered and hovered.has_method("interact"):
				hovered.interact(player)
			# Optional: if already holding something and not looking at an interactable,
			# you can “use” the held item on tap:
			# elif _hands and _hands.has_item() and _hands.held and _hands.held.has_method("use"):
			#     _hands.held.use(player)

		# reset
		_interact_down = false
		_interact_time = 0.0
		_drop_fired = false
		
	if event.is_action_pressed("use") and player and player.has_node("Hands"):
		var hands := player.get_node("Hands") as Hands
		if hands and hands.has_item() and hands.held and hands.held.has_method("use"):
			hands.held.use(player)

func _find_interactable_root(n: Node) -> Node3D:
	var cur := n
	while cur:
		if cur.is_in_group("interactable"):
			return cur as Node3D
		cur = cur.get_parent()
	return null

func _configure_ray() -> void:
	ray.enabled = true
	ray.collide_with_areas = true
	ray.collide_with_bodies = true
	ray.exclude_parent = true
	ray.collision_mask = mask
	ray.target_position = Vector3(0, 0, -max_distance)
