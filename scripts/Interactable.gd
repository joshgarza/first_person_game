class_name Interactable
extends Node3D

@export var hover_color: Color = Color(1.0, 1.0, 0.6, 1.0) # soft yellow

var _meshes: Array[MeshInstance3D] = []
var _hover_mats: Array[StandardMaterial3D] = []

func _ready() -> void:
	# Collect ALL meshes under this node
	_meshes = []
	_hover_mats = []
	_get_meshes_recursive(self)

	# Build one overlay material per mesh (lets you vary intensity later if needed)
	for _i in _meshes.size():
		var m := StandardMaterial3D.new()
		m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		m.albedo_color = hover_color
		m.emission_enabled = true
		m.emission = hover_color
		m.emission_energy_multiplier = 1.2
		_hover_mats.append(m)

func _get_meshes_recursive(n: Node) -> void:
	for child in n.get_children():
		if child is MeshInstance3D:
			_meshes.append(child)
		_get_meshes_recursive(child)

func on_hover_start() -> void:
	for i in _meshes.size():
		_meshes[i].material_overlay = _hover_mats[i]

func on_hover_end() -> void:
	for mi in _meshes:
		mi.material_overlay = null

func interact(_actor: Node) -> void:
	# Intentionally no-op; subclasses (e.g., Holdable, Door) implement behavior.
	pass
