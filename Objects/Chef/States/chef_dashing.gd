extends ChefBaseState

var after_image = preload("res://Objects/Chef/DashAfterImage.tscn")
var spawn_timer: float = 0.0
var spawn_interval: float = 0.09  # spawn every 0.1s

func enter() -> void:
	
	var chef := entity as Chef
	spawn_timer = 0.0
	if not chef.dash_controller.is_on_cooldown:
		chef.sfx_controller.play(SFXController.SFX.ATTACK)
		chef.sprite.play("Dash")
		chef.dash_controller.start_dash(Vector2(chef.character_movement.facing, 0))
		_spawn_after_image(chef)

func process(delta: float) -> int:
	var chef := entity as Chef
	chef.dash_controller.process_dash(delta)

	# Spawn afterimage every 0.1s while dashing
	if chef.dash_controller.is_dashing:
		spawn_timer -= delta
		if spawn_timer <= 0.0:
			spawn_timer = spawn_interval
		return ChefBaseState.State.Dashing

	return ChefBaseState.State.Idle


func _spawn_after_image(chef: Chef) -> void:
	var after_image_node = after_image.instantiate() as AnimatedSprite2D
	after_image_node.global_position = chef.global_position
	after_image_node.flip_h = chef.character_movement.facing < 0

	# Darken current game color
	var base_color: Color = ColorController.COLOR_MAP[ColorController.current_game_color]
	var darkened_color: Color = base_color * Color(0.6, 0.6, 0.6, 1.0)
	after_image_node.modulate = darkened_color

	# Add afterimage to same parent as chef (so it doesn't disappear when state exits)
	chef.get_parent().add_child(after_image_node)
