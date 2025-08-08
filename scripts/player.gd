extends CharacterBody3D

@onready var movement: Movement = $Movement
@onready var camera: Camera3D = $Camera3D
@onready var stats: Stats = $Stats
@onready var needs: Needs = $Needs

func _ready() -> void:
	movement.player = self
	movement.camera = camera
	pass

func _physics_process(delta: float) -> void:
	movement._physics_process(delta)

#func _process(delta: float) -> void:
	#needs._process(delta)
