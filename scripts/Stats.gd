class_name Stats
extends Node

signal hunger_critical  # emitted when hunger < 20
signal health_changed(old_value: float, new_value: float)

var hunger := 100.0
var thirst := 100.0
var stamina := 100.0
var is_bleeding := false
var health := 100.0
