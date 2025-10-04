extends Node
@export var intensity: float = 0.5
@export var node_color: ColorController.GameColor = ColorController.GameColor.WHITE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if node_color == ColorController.GameColor.WHITE:
		tint_node()
	elif node_color != ColorController.current_game_color:
		get_parent().visible = false
		if get_parent() is TileMapLayer:
			get_parent().collision_enabled = false
		else:
			for child in get_parent().get_children():
				if child is CollisionShape2D:
					child.disabled = true
	elif node_color == ColorController.current_game_color:
		tint_node()
		get_parent().visible = true
		
		if get_parent() is TileMapLayer:
			get_parent().collision_enabled = true
		else:
			for child in get_parent().get_children():
				if child is CollisionShape2D:
					child.disabled = false
	
func tint_node() -> void:
	if get_parent().material != null:
		get_parent().material.set_shader_parameter("tint_color", ColorController.current_game_color)
	else:
		get_parent().modulate = ColorController.COLOR_MAP[ColorController.current_game_color].lightened(intensity)
