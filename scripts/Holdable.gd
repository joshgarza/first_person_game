class_name Holdable
extends Interactable

var _original_parent: Node = null
var _original_xform: Transform3D
var _held: bool = false

func _get_static_body() -> StaticBody3D:
	return get_node_or_null("StaticBody3D") as StaticBody3D

func pickup(holder: Node) -> void:
	if _held:
		return
	_original_parent = get_parent()
	_original_xform = global_transform
	_held = true

	# Disable collisions while held
	var sb := _get_static_body()
	if sb:
		sb.set_deferred("collision_layer", 0)
		sb.set_deferred("collision_mask", 0)

	# Reparent to hand socket, preserving world transform
	var socket := holder.get_node("Hands/Socket") as Node3D
	var keep := global_transform
	reparent(socket)
	global_transform = keep

	# Snap to socket (optional hard snap — comment out if you want offset preserved)
	global_transform = socket.global_transform

func drop(holder: Node) -> void:
	if not _held:
		return
	_held = false

	# Re-enable collisions
	var sb := _get_static_body()
	if sb:
		sb.set_deferred("collision_layer", 1) # adjust to your world layer
		sb.set_deferred("collision_mask", 1)

	# Put back under the original parent and place in front of camera
	var cam := holder.get_node("Head/Camera3D") as Camera3D
	var drop_pos: Vector3 = cam.global_transform.origin + (-cam.global_transform.basis.z * 0.8)

	var keep := global_transform
	reparent(_original_parent)
	global_transform = keep

	var t := global_transform
	t.origin = drop_pos
	global_transform = t

func interact(actor: Node) -> void:
	if actor.has_node("Hands"):
		var hands := actor.get_node("Hands") as Hands
		if hands.has_item():
			return
		pickup(actor)
		hands.set_item(self)
