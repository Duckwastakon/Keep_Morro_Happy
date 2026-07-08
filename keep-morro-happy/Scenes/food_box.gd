extends Area2D

@export var foodId: int = 2
var infoText = null

func _ready() -> void:
	infoText = ExtraVisuals.loadInfo(self, "Press e to grab cat food")

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		player.pickUpId = foodId
		infoText.visible = true


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		if player.pickUpId == foodId:
			player.pickUpId = null
			infoText.visible = false
