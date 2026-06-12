extends Area2D

@export var neededId = 0
@export var outcomeId = 3

var itemPrefab = preload("res://CharacterScenes/item.tscn")

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is not CharacterBody2D:
		return
	
	var id = -1
	if area.get_parent().name == "player":
		id = area.get_parent().pickedUpItem
		if id == neededId:
			area.get_parent().pickUpItem(outcomeId)
			queue_free()
	else:
		id = area.get_parent().id
		if id == neededId:
			area.get_parent().queue_free()
			var newItem = itemPrefab.instantiate()
			newItem.id = 3
			newItem.global_position = global_position
			get_parent().add_child(newItem)
			queue_free()
