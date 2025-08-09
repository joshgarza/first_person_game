extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var hands: Hands = $Hands
@onready var movement: Movement = $Movement
@onready var interaction: Interaction = $Interaction
@onready var camera: Camera3D = $Head/Camera3D
@onready var stats: Stats = $Stats
@onready var needs: Needs = $Needs
@onready var hud := get_tree().get_first_node_in_group("hud") as DebugHUD

func _ready() -> void:
	if hud:
		print(hud)
		hud.player = self

	movement.player = self
	movement.camera = camera
	interaction.player = self
	interaction.camera = camera
	camera.current = true
	camera.cull_mask = (1 << 20) - 1  # see all 20 visual layers
	print("Camera cull_mask:", camera.cull_mask)


	pass

func _physics_process(delta: float) -> void:
	movement._physics_process(delta)

func _process(delta: float) -> void:
	needs._process(delta)
