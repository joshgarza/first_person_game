extends Holdable
class_name Food

@export var nutrition: float = 25.0

func use(actor: Node) -> void:
	if not actor.has_node("Stats"): return
	var stats := actor.get_node("Stats")
	stats.hunger = clamp(stats.hunger + nutrition, 0.0, 100.0)

	# if we’re currently held, clear the Hands reference
	if actor.has_node("Hands"):
		var hands := actor.get_node("Hands") as Hands
		if hands and hands.held == self:
			hands.held = null

	queue_free()
