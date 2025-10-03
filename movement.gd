extends Area2D

@onready var panel = $"../Panel"  # adjust path to your Panel

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	panel.visible = false  # start hidden

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Chef"):  # make sure your Chef is in group "Player"
		panel.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Chef"):  # make sure your Chef is in group "Player"
		panel.visible = false
