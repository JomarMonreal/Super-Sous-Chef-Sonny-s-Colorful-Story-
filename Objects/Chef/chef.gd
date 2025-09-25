extends CharacterBody2D
class_name Chef


@onready var states: ChefStateManager = $ChefStateManager
@onready var character_movement: SideScrollingMovement = $SideScrollingMovement
@onready var dash_controller: DashController = $DashController
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal dashing

func _ready() -> void:
	states.init(self)
	
func _process(delta: float) -> void:
	states.process(delta)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)
	

func _on_dash_controller_dash_start() -> void:
	emit_signal("dashing")
