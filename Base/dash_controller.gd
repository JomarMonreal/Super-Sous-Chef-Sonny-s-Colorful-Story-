extends Node
class_name DashController

@export var dash_distance: float = 700.0
@export var dash_speed: float = 5000.0
@export var dash_scale: float = 0.5 # (currently unused; keep if you’ll add VFX)
@export var dash_cooldown: float = 0.5
@export var dash_delay: float = 0.0 # delay (in seconds) before movement begins

var is_dashing: bool = false
var is_on_cooldown: bool = false
var is_delaying: bool = false
var initial_position: Vector2
var target_position: Vector2
var direction: Vector2
var controlled_body: CharacterBody2D

signal dash_start
signal dash_finished
signal cooldown_finished

@onready var cooldown_timer: Timer = $DashingCooldownTimer
@onready var delay_timer: Timer = $DashDelayTimer

func _ready() -> void:
	if owner is CharacterBody2D:
		controlled_body = owner as CharacterBody2D
	else:
		push_error("DashController must be a child of a CharacterBody2D node.")

	if cooldown_timer:
		cooldown_timer.one_shot = true
		cooldown_timer.wait_time = dash_cooldown
	else:
		push_error("Missing Timer node: DashingCooldownTimer")

	if delay_timer:
		delay_timer.one_shot = true
	else:
		push_error("Missing Timer node: DashDelayTimer")

func _physics_process(delta: float) -> void:
	if is_dashing:
		process_dash(delta)

func start_dash(direction_vector: Vector2) -> void:
	if is_dashing or is_on_cooldown:
		return

	direction = direction_vector.normalized()
	if direction == Vector2.ZERO:
		return

	initial_position = controlled_body.global_position
	target_position = initial_position + direction * dash_distance

	if dash_delay > 0.0 and delay_timer:
		delay_timer.start(dash_delay)
		is_delaying = true
	else:
		_begin_dash()

func _begin_dash() -> void:
	is_delaying = false
	is_dashing = true
	is_on_cooldown = true
	dash_start.emit()

func process_dash(delta: float) -> void:
	if not is_dashing:
		return

	var to_target: Vector2 = target_position - controlled_body.global_position
	var step_len: float = min(dash_speed * delta, to_target.length())
	if step_len <= 0.0001:
		_finish_dash()
		return

	var motion: Vector2 = direction * step_len
	var collision := controlled_body.move_and_collide(motion)

	if collision:
		_finish_dash()
		return

	if controlled_body.global_position.distance_to(target_position) <= 0.5:
		_finish_dash()

func _finish_dash() -> void:
	is_dashing = false
	if cooldown_timer:
		cooldown_timer.start()
	dash_finished.emit()

func _on_dashing_cooldown_timer_timeout() -> void:
	is_on_cooldown = false
	if cooldown_timer:
		cooldown_timer.stop()
	cooldown_finished.emit()

func _on_dash_delay_timer_timeout() -> void:
	if delay_timer:
		delay_timer.stop()
	_begin_dash()
