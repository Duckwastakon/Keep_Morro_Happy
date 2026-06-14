extends Area2D

@export var bagId: int = 0
@export var binItems = 3
var infoText = null

func _ready() -> void:
	infoText = ExtraVisuals.loadInfo(self, "Press e to grab " + Global.Items[bagId]["name"])

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		if player.pickedUpItem == binItems:
			player.removeItem()
		
		player.pickUpId = bagId
		infoText.visible = true
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
			infoText.visible = false
