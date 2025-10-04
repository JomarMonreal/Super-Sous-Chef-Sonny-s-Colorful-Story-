extends EnemyBaseState

@export var left_ray: RayCast2D
@export var right_ray: RayCast2D

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var enemy := entity as Boss
	enemy.sprite.play(enemy.node_color_name + " Moving")
	
func decide_attack() -> EnemyBaseState.State:
	if randi_range(0,100) > 50:	#Randomize between attacking and guarding
		return EnemyBaseState.State.Attaking
	else:
		return EnemyBaseState.State.Guarding

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var enemy := entity as Boss
	
	if enemy.node_color == ColorController.current_game_color:
		left_ray.set_collision_mask_value(3, false)
		right_ray.set_collision_mask_value(3, false)
	else:
		left_ray.set_collision_mask_value(3, true)
		right_ray.set_collision_mask_value(3, true)
	if !enemy.dash_controller.is_dashing and !enemy.dash_controller.is_on_cooldown:
		if left_ray.is_colliding() and enemy.character_movement.direction < 0:
			if left_ray.get_collider() is Chef:
				return decide_attack()
		if right_ray.is_colliding() and enemy.character_movement.direction > 0:
			if right_ray.get_collider() is Chef:
				return decide_attack()
		
	enemy.character_movement.move(delta)		
	return EnemyBaseState.State.Moving


func _on_boss_change_color() -> void:
	var enemy := entity as Boss
	enemy.sprite.play(enemy.node_color_name + " Moving")
