extends Area2D

@export var interactTask = "wires"
var infoText = null
@onready var spriteDisplay = $sprite

var task: Control

signal taskCompleated

var taskDisplayInfo = {
	"wires": {
		"sprite": "res://Assets/Art/wireStation.png",
		"scaleAmount": Vector2.ONE,
		"info": "Press e to fix wires",
		"scale": 2.5,
	},
	"coffee": {
		"sprite": "res://Assets/Art/coffeeMachine.png",
		"scaleAmount": Vector2.ONE,
		"info": "Press e to make coffee",
		"scale": 2.5,
	},
	"homework": {
		"sprite": "res://Assets/Art/homeworkTable.png",
		"scaleAmount": Vector2.ONE,
		"info": "Press e to do homework",
		"scale": 2.5,
	},
	"dishes": {
		"sprite": "res://Assets/Art/sink.png",
		"scaleAmount": Vector2.ONE,
		"info": "Press e to do the dishes",
		"scale": 2.5,
	}
}

func _ready() -> void:
	var taskData = taskDisplayInfo[interactTask]
	infoText = ExtraVisuals.loadInfo(self, taskData["info"])
	spriteDisplay.texture = load(taskData["sprite"])
	spriteDisplay.scale = Vector2(taskData["scale"], taskData["scale"])
	
	var newTask = load("res://Scenes/taskClonables/" + interactTask + ".tscn").instantiate()
	tasks.add_child(newTask)
	newTask.station = self
	task = newTask
	
	connect("taskCompleated", complete)

func complete():
	spriteDisplay.material.set_shader_parameter("speed", 0)

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
