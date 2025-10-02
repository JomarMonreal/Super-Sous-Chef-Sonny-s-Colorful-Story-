extends CharacterBody2D
class_name Enemy

@onready var states: EnemyStateManager = $EnemyStateManager
@onready var character_movement: SideScrollingWalkMovement = $SideScrollingWalkMovement
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_controller: DashController = $DashController
@onready var health_controller: HealthController = $HealthController

var collider_entered: Node2D

func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	


func _on_health_controller_damaged(amount: float) -> void:
	states.change_state(EnemyBaseState.State.Hurt)


func _on_health_controller_dead() -> void:
	queue_free()
