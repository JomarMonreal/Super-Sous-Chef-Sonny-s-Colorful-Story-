extends Control

@export var max_hp: int = 3
@export var current_hp: int = 3:
	set(value):
		current_hp = clamp(value, 0, max_hp)
		_update_health_bar()

@export var heart_texture: Texture2D
@onready var hearts_container: HBoxContainer = $HeartsContainer

func _ready() -> void:
	_update_health_bar()

func _update_health_bar() -> void:
	# Clear previous hearts
	for child in hearts_container.get_children():
		child.queue_free()

	# Draw hearts equal to current_hp
	for i in range(current_hp):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hearts_container.add_child(heart)


func _on_chef_hurt(amount: int) -> void:
	current_hp -= amount
