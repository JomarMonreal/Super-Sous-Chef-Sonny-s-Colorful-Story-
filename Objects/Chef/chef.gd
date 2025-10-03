extends CharacterBody2D
class_name Chef


@onready var states: ChefStateManager = $ChefStateManager
@onready var character_movement: SideScrollingMovement = $SideScrollingMovement
@onready var dash_controller: DashController = $DashController
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_controller: HealthController = $HealthController
var colors_unlocked: Array[String] = []

var enemy_entered: Node2D

signal dashing


func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	# WARN: THIS SHIT IS ASS
	$AnimatedSprite2D/ColorComponent.node_color = ColorController.current_game_color
	# END OF ASS
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	

func _on_dash_controller_dash_start() -> void:
	emit_signal("dashing")



func _on_hitbox_body_entered(body: Node2D) -> void:
	if ((body is Enemy or body is Bullet) and !health_controller.is_hurt and !dash_controller.is_on_cooldown):
		if body is Enemy:
			
			health_controller.take_damage(1)
			enemy_entered = body
			
			if health_controller.health <= 0:
				return states.change_state(ChefBaseState.State.Dead)
			states.change_state(ChefBaseState.State.Hurt)



func _on_dash_controller_dash_interrupted(body: Node2D) -> void:
	if ((body is Enemy or body is Bullet) and !health_controller.is_hurt):
		if body is Enemy:
			enemy_entered = body
			enemy_entered.collider_entered = self
			if body.states.current_state != body.states.states[EnemyBaseState.State.Guarding]:
				print("enemy color: ", body.node_color)
				print("chef color: ", $AnimatedSprite2D/ColorComponent.node_color)
				if body.node_color == ColorController.COMPLEMENTARY_MAP[$AnimatedSprite2D/ColorComponent.node_color]:
					body.health_controller.take_damage(1)
			else:
				health_controller.take_damage(1)
				
				if health_controller.health <= 0:
					return states.change_state(ChefBaseState.State.Dead)
				states.change_state(ChefBaseState.State.Hurt)
		print(health_controller.health)


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Fruit:
		Fruits.colors_eaten.append(area.node_color)
		area.eat()
	pass # Replace with function body.
