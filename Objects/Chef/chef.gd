extends CharacterBody2D
class_name Chef


@onready var states: ChefStateManager = $ChefStateManager
@onready var character_movement: SideScrollingMovement = $SideScrollingMovement

func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
