class_name Hands
extends Node3D

var held: Holdable = null

func has_item() -> bool:
	return held != null

func set_item(item: Holdable) -> void:
	held = item

func drop_current() -> void:
	if held:
		var h := held
		held = null
		h.drop(get_parent()) # parent is Player
