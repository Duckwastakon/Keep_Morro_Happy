extends Area2D

@export var interactTask = "wires"
var infoText = null
@onready var spriteDisplay = $sprite

var task: Control

signal taskCompleated

var taskDisplayInfo = {
	"wires": {
		"sprite": "",
		"scaleAmount": Vector2.ONE,
		"info": "Press e to fix wires"
	},
	"coffee": {
		"sprite": "",
		"scaleAmount": Vector2.ONE,
		"info": "Press e to make coffee"
	},
	"homework": {
		"sprite": "",
		"scaleAmount": Vector2.ONE,
		"info": "Press e to do homework"
	},
	"dishes": {
		"sprite": "",
		"scaleAmount": Vector2.ONE,
		"info": "Press e to do the dishes"
	}
}

func _ready() -> void:
	var taskData = taskDisplayInfo[interactTask]
	infoText = ExtraVisuals.loadInfo(self, taskData["info"])
	spriteDisplay.texture = load(taskData["sprite"])
	
	var newTask = load("res://Scenes/taskClonables/" + interactTask + ".tscn").instantiate()
	tasks.add_child(newTask)
	newTask.station = self
	task = newTask

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		player.interactTask = task
		infoText.visible = true

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		player.interactTask = null
		infoText.visible = false
