extends Area2D

@export var bagId = 0
@export var binItems = 3


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		if player.pickedUpItem == binItems:
			player.removeItem()
		
		player.pickUpId = bagId
	else:
		if area.get_parent() is CharacterBody2D:
			var id = area.get_parent().id
			if id == binItems:
				area.get_parent().queue_free()


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		if player.pickUpId == bagId:
			player.pickUpId = null
