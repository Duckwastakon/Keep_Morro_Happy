extends Node

var completeTasks = []
var broomSpawned = false

@export var taskStationContainer: Node2D = null

func _ready() -> void:
	GameUi.setActive()
	
	generateTasks()
	
	GameUi.Gametimer()

func generateTasks():
	var allTasks = Global.tasks
	
	if taskStationContainer == null:
		return
	
	var taskStationSpots = taskStationContainer.get_children()
	
	var taskAmount = 3
	
	for i in taskAmount:
		var randT = randi_range(0, allTasks.size() - 1)
		var randS = randi_range(0, taskStationSpots.size() - 1)
		
		var randTask = allTasks[randT]
		allTasks.remove_at(randT)
		
		var randStation = taskStationSpots[randS]
		taskStationSpots.remove_at(randS)
		
		call(randTask.bind(randStation))

func books(station):
	pass
