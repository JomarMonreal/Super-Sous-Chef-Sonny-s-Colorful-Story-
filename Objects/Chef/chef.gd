extends CharacterBody2D
class_name Chef


@onready var states: ChefStateManager = $ChefStateManager
@onready var character_movement: SideScrollingMovement = $SideScrollingMovement
@onready var dash_controller: DashController = $DashController
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_controller: HealthController = $HealthController

var enemy_entered: Node2D

signal dashing


func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	

func _on_dash_controller_dash_start() -> void:
	emit_signal("dashing")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if ((body is Enemy or body is Bullet) and !health_controller.is_hurt):
		if body is Enemy:
			if dash_controller.is_dashing and body.states.current_state != body.states.states[EnemyBaseState.State.Guarding]:
				body.health_controller.take_damage(1)
			else:
				health_controller.take_damage(1)
				
				if health_controller.health <= 0:
					return states.change_state(ChefBaseState.State.Dead)
				states.change_state(ChefBaseState.State.Hurt)
		print(health_controller.health)
