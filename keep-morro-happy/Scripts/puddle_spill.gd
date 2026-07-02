extends Area2D

@export var broomId = 4

func _ready() -> void:
	$SpillSheet.frame = randi_range(0, 2)
	$SpillSheet.modulate.a = randf_range(0.6, 0.95)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		if player.pickedUpItem == broomId:
			await player.clean()
			queue_free()
