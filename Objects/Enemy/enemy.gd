extends CharacterBody2D
class_name Enemy

@export var node_color: ColorController.GameColor

@onready var states: EnemyStateManager = $EnemyStateManager
@onready var character_movement: SideScrollingWalkMovement = $SideScrollingWalkMovement
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_controller: DashController = $DashController
@onready var health_controller: HealthController = $HealthController
@onready var sfx_controller: SFXController = $SFXController

var collider_entered: Node2D

func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	if node_color == ColorController.current_game_color:
		set_collision_layer_value(4, false)
	else:
		set_collision_layer_value(4, true)
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	


func _on_health_controller_damaged(amount: float) -> void:
	states.change_state(EnemyBaseState.State.Hurt)


func _on_health_controller_dead() -> void:
	await sfx_controller.play(SFXController.SFX.DIE)
	states.change_state(EnemyBaseState.State.Attaking)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
	await tween.finished
	queue_free()
