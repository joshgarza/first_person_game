class_name Needs
extends Node
@onready var stats: Stats = $"../Stats"

# In Needs class
var hunger_timer: float = 0.0
const HUNGER_DECAY_RATE: float = 0.05  # per second
const HUNGER_TICK_INTERVAL: float = 1.0  # seconds

func _process(delta: float) -> void:
	hunger_timer += delta
	if hunger_timer >= HUNGER_TICK_INTERVAL:
		stats.hunger -= HUNGER_DECAY_RATE
		stats.hunger = clamp(stats.hunger, 0, 100)
		hunger_timer = 0.0
