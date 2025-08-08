class_name Needs
extends Node
@onready var stats: Stats = $"../Stats"

func _process(delta: float) -> void:
	stats.hunger -= 0.05 * delta
	stats.hunger = clamp(stats.hunger, 0, 100)
	print(stats.hunger)

	#if stats.hunger < 20:
		# apply consequence, or emit signal
