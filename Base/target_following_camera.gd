extends Camera2D

# ── Inspector-exposed settings ────────────────────────────────────────────────
@export_range(0.05, 100.0, 0.05)
var default_zoom_scale: float = 3.5            # The steady-state zoom (Vector2 = 3.5, 3.5).

@export_range(0.1, 60.0, 0.1)
var lerp_speed: float = 8.0                    # Higher = snappier follow.

@export var target: Node2D                     # Drag the node to follow here (optional).
@export var target_path: NodePath              # Or set a path to the target (optional).

@export_range(0.1, 60.0, 0.1)
var zoom_lerp_speed: float = 8.0               # Higher = faster zoom interpolation.

@export_range(0.05, 100.0, 0.05)
var min_zoom_scale: float = 0.2                # Clamp for zooming out (smaller number = farther out).

@export_range(0.05, 100.0, 0.05)
var max_zoom_scale: float = 10.0               # Clamp for zooming in (bigger number = closer in).

# ── Internals ─────────────────────────────────────────────────────────────────
const ZOOM_EPSILON: float = 0.01

var _transient_zoom_active: bool = false       # If true, lerp toward a temporary zoom target.
var _transient_zoom_hold: float = 0.0          # Seconds to hold at transient target once reached.
var _transient_zoom_target: Vector2 = Vector2.ZERO

# ── Lifecycle ─────────────────────────────────────────────────────────────────
func _ready() -> void:
	# Resolve target via path if direct reference was not provided.
	if target == null and target_path != NodePath():
		target = get_node_or_null(target_path) as Node2D

	# Keep default within the allowed range.
	default_zoom_scale = clampf(default_zoom_scale, min_zoom_scale, max_zoom_scale)

# ── Internals ─────────────────────────────────────────────────────────────────
const ZOOM_EPS_ABS: float = 0.003   # absolute floor
const ZOOM_EPS_REL: float = 0.01    # within 1% of target counts as “arrived”

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		return

	# Follow
	var goal_pos: Vector2 = target.global_position + offset
	var t: float = clampf(delta * lerp_speed, 0.0, 1.0)
	global_position = global_position.lerp(goal_pos, t)

	# Choose zoom goal	var tz: float = clampf(delta * zoom_lerp_speed, 0.0, 1.0)
	var goal_zoom: Vector2 = _transient_zoom_target if _transient_zoom_active else Vector2.ONE * default_zoom_scale

	# Lerp zoom
	var tz: float = clampf(delta * zoom_lerp_speed, 0.0, 1.0)
	var arrive_eps: float = maxf(ZOOM_EPS_ABS, goal_zoom.x * ZOOM_EPS_REL)
	var arrived: bool = zoom.distance_to(goal_zoom) <= arrive_eps

	if not arrived:
		zoom = zoom.lerp(goal_zoom, tz)
	else:
		# Snap once inside the band
		zoom = goal_zoom

		# If transient and no hold, release immediately so we start heading back.
		if _transient_zoom_active:
			if _transient_zoom_hold > 0.0:
				_transient_zoom_hold = maxf(_transient_zoom_hold - delta, 0.0)
			if _transient_zoom_hold == 0.0:
				_transient_zoom_active = false


# ── Utilities ─────────────────────────────────────────────────────────────────
func set_target(node: Node2D) -> void:
	target = node

func snap_to_target() -> void:
	if target:
		global_position = target.global_position + offset

# ── Zoom Controls ─────────────────────────────────────────────────────────────
## Smoothly zooms relative to the current zoom.
## @param factor   >1.0 zooms in; <1.0 zooms out.
## @param hold_s   Optional seconds to hold at the new zoom before gliding back.
func zoom_by(factor: float, hold_s: float = 0.0) -> void:
	var current_scale: float = zoom.x
	var target_scale: float = clampf(current_scale * factor, min_zoom_scale, max_zoom_scale)
	_set_transient_zoom_target(target_scale, hold_s)

# Zoom IN should multiply by < 1
func zoom_in(factor: float = 1.25, hold_s: float = 0.0) -> void:
	zoom_by(1.0 / maxf(factor, 1.0001), hold_s)

# Zoom OUT should multiply by > 1
func zoom_out(factor: float = 1.25, hold_s: float = 0.0) -> void:
	zoom_by(maxf(factor, 1.0001), hold_s)

## Smoothly zooms to an absolute scale.
## @param scale    Absolute zoom scale to target.
## @param hold_s   Optional seconds to hold before returning to default.
func zoom_to(scale: float, hold_s: float = 0.0) -> void:
	_set_transient_zoom_target(clampf(scale, min_zoom_scale, max_zoom_scale), hold_s)

# ── Internals: Zoom Helpers ───────────────────────────────────────────────────
func _set_transient_zoom_target(scale: float, hold_s: float) -> void:
	_transient_zoom_target = Vector2.ONE * scale
	_transient_zoom_hold = maxf(hold_s, 0.0)
	_transient_zoom_active = true

func _on_chef_dashing() -> void:
	zoom_out()
