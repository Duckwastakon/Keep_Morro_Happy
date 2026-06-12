extends Area2D

@export var broomId = 4

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		if player.pickedUpItem == broomId:
			await player.clean()
			queue_free()
