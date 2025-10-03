extends Area2D
class_name Fruit

@export var node_color: ColorController.GameColor = ColorController.GameColor.WHITE
@export var texture: Texture2D

@onready var sprite = $Sprite2D
var was_eaten = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func eat():
	if not was_eaten:
		was_eaten = true
		$AnimationPlayer.play("enlarge")
		await $AnimationPlayer.animation_finished
		change_scene()
		queue_free()
		
func change_scene() -> void:
	if node_color in Fruits.fruit_path_map:
		var next_scene = Fruits.fruit_path_map[node_color]
		if next_scene:
			get_tree().change_scene_to_file(next_scene)
