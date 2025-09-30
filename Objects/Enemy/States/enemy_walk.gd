extends EnemyBaseState

@export var left_ray: RayCast2D
@export var right_ray: RayCast2D

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var enemy := entity as Enemy
	enemy.sprite.play("Moving")
	
func decide_attack() -> EnemyBaseState.State:
	if randi_range(0,100) > 50:	#Randomize between attacking and guarding
		return EnemyBaseState.State.Attaking
	else:
		return EnemyBaseState.State.Guarding

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var enemy := entity as Enemy
	
	if !enemy.dash_controller.is_dashing and !enemy.dash_controller.is_on_cooldown:
		if left_ray.is_colliding() and enemy.character_movement.direction < 0:
			if left_ray.get_collider() is Chef:
				return decide_attack()
		if right_ray.is_colliding() and enemy.character_movement.direction > 0:
			if right_ray.get_collider() is Chef:
				return decide_attack()
		
	enemy.character_movement.move(delta)		
	return EnemyBaseState.State.Moving
