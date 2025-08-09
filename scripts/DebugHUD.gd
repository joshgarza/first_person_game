extends CanvasLayer
class_name DebugHUD

@export var player: Node3D    # drag Player in the editor OR set from code

@onready var _hunger: Label = $PanelContainer/MarginContainer/VBoxContainer/hunger
@onready var _thirst: Label = $PanelContainer/MarginContainer/VBoxContainer/thirst
@onready var _health: Label = $PanelContainer/MarginContainer/VBoxContainer/health
@onready var _title:  Label = $PanelContainer/MarginContainer/VBoxContainer/title

var _stats: Node = null
var _use_poll := true  # flips to false if Stats emits a signal we can use

func _ready() -> void:
	if player:
		print(player)
		_title.text = "DEBUG — Stats"
		_try_wire_stats()

func _process(_dt: float) -> void:
	if _use_poll and _stats:
		_update_text()

func _try_wire_stats() -> void:
	if player == null:
		push_warning("DebugHUD: player not set; drag it in the inspector or set via code.")
		return
	_stats = player.get_node_or_null("Stats")
	if _stats == null:
		push_warning("DebugHUD: Player has no 'Stats' node.")
		return
	# If your Stats.gd exposes a signal, prefer event-driven updates
	if "stats_changed" in _stats.get_signal_list():
		_use_poll = false
		_stats.connect("stats_changed", Callable(self, "_on_stats_changed"))
		_update_text()
	else:
		_use_poll = true  # fall back to polling

func _on_stats_changed(_hunger: float, _thirst: float, _health: float) -> void:
	_update_text()

func _val(n: Variant, def: float = 0.0) -> float:
	return float(n) if typeof(n) in [TYPE_FLOAT, TYPE_INT] else def

func _update_text() -> void:
	if _stats == null: return
	var hunger  := _val(_stats.get("hunger"))
	var thirst  := _val(_stats.get("thirst"))
	var health  := _val(_stats.get("health"))
	_hunger.text = "Hunger:  %.1f" % hunger
	_thirst.text = "Thirst:  %.1f" % thirst
	_health.text = "Health:  %.1f" % health

# Optional: toggle with F1 (add InputMap action "toggle_hud")
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_hud"):
		visible = not visible
