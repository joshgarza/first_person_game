class_name Food
extends Node3D

@export var nutrition: float = 25.0
@export var spoilage: float = 0.0 # 0–1 later, ignore for now

func interact(actor: Node) -> void:
	if not actor.has_node("Stats"): return
	var stats: Node = actor.get_node("Stats") # your Stats.gd node
	stats.hunger = clamp(stats.hunger + nutrition, 0.0, 100.0)
	queue_free()
