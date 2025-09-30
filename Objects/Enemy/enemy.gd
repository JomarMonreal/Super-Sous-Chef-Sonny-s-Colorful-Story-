extends CharacterBody2D
class_name Enemy

@onready var states: EnemyStateManager = $EnemyStateManager
@onready var character_movement: SideScrollingWalkMovement = $SideScrollingWalkMovement
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_controller: DashController = $DashController

func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	
