extends Camera2D

# ── Inspector-exposed settings ────────────────────────────────────────────────
@export var target: Node2D                      # Drag the node to follow here (optional).
@export var target_path: NodePath               # Or set a path to the target (optional).
@export_range(0.1, 60.0, 0.1)
var lerp_speed: float = 8.0                     # Higher = snappier follow.

# ── Lifecycle ─────────────────────────────────────────────────────────────────
func _ready() -> void:
	# Resolve target via path if direct reference was not provided.
	if target == null and target_path != NodePath():
		target = get_node_or_null(target_path) as Node2D

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return

	var goal: Vector2 = target.global_position + offset
	# Linear interpolation with frame-rate–independent weight.
	var t: float = clampf(delta * lerp_speed, 0.0, 1.0)
	global_position = global_position.lerp(goal, t)

# ── Utilities ─────────────────────────────────────────────────────────────────
func set_target(node: Node2D) -> void:
	target = node

func snap_to_target() -> void:
	if target:
		global_position = target.global_position + offset
