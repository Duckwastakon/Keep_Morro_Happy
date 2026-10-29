extends Area2D

@onready var sprite = $itemImage

func _on_mouse_entered() -> void:
	sprite.modulate = Color(1.0, 0.444, 0.375, 1.0)

func _on_mouse_exited() -> void:
	sprite.modulate = Color.WHITE
