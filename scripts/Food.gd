extends Holdable
class_name Food

@export var nutrition: float = 25.0

# Optional: if you want to eat while held later, add a use() method:
func use(actor: Node) -> void:
	if not actor.has_node("Stats"): return
	var stats: Node = actor.get_node("Stats")
	# assuming 0..100 hunger, where higher = fuller
	stats.hunger = clamp(stats.hunger + nutrition, 0.0, 100.0)
	# after eating, remove from hands + world
	if actor.has_node("Hands"):
		var hands: Hands = actor.get_node("Hands")
		if hands.call("has_item"):
			hands.call("drop_current") # puts it in world; you can instead queue_free here
	queue_free()
