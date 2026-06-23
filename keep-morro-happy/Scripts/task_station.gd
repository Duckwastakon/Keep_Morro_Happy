extends Area2D

@export var interactTask = "wires"
var infoText = null

func _ready() -> void:
	infoText = ExtraVisuals.loadInfo(self, "Press e to do " + interactTask)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		player.interactTask = interactTask
		infoText.visible = true


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		player.interactTask = null
		infoText.visible = false
