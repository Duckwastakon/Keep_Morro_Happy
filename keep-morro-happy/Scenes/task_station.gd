extends Area2D

@export var interactTask = "Wires"


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		player.interactTask = interactTask


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		player.interactTask = null
