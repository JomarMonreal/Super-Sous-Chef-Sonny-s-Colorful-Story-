extends EnemyBaseState

var BulletScene = preload("res://Objects/Bullet/Bullet.tscn")
	
# Called when the node enters the scene tree for the first time.
func enter() -> void:
	var enemy := entity as Boss
	enemy.sprite.play(enemy.node_color_name + " Attacking")
	enemy.dash_controller.start_dash(Vector2(enemy.character_movement.direction, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> int:
	var enemy := entity as Boss
	enemy.dash_controller.process_dash(delta)	
	if !enemy.dash_controller.is_dashing and !enemy.dash_controller.is_on_cooldown and !enemy.dash_controller.is_delaying:
		return EnemyBaseState.State.Moving
		
	return EnemyBaseState.State.Attaking

func _on_dash_controller_dash_start() -> void:
	var enemy := entity as Boss
	var new_bullet_instance = BulletScene.instantiate() as RigidBody2D
	var movement = new_bullet_instance.get_child(0) as OneDirectionalMovement
	var sprite = new_bullet_instance.get_child(1) as AnimatedSprite2D
	movement.direction = Vector2(enemy.character_movement.direction, 0)
	sprite.flip_h = enemy.character_movement.direction > 0
	
	var offset = enemy.character_movement.direction * 20
	new_bullet_instance.global_position.x = enemy.global_position.x  + offset
	new_bullet_instance.global_position.y = enemy.global_position.y
	
	add_child(new_bullet_instance)
	pass # Replace with function body.


func _on_boss_change_color() -> void:
	var enemy := entity as Boss
	enemy.sprite.play(enemy.node_color_name + " Attacking")
	enemy.dash_controller.start_dash(Vector2(enemy.character_movement.direction, 0))
