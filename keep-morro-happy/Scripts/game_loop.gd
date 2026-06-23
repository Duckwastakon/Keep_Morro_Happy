extends Node

var tasks = {}
var stations = []
var broomSpawned = false

@onready var map = $map
@onready var tileSize = map.tileSize

var bookShelf = preload("res://Scenes/bookshelf.tscn")
var taskStation = preload("res://Scenes/task_station.tscn")
var puddle = preload("res://Scenes/puddle_spill.tscn")
var poopInstance = preload("res://CharacterScenes/poop.tscn")

var trashBin = preload("res://Scenes/trash_bin.tscn")
var item = preload("res://CharacterScenes/item.tscn")
@export var broomId = 4

func _ready() -> void:
	GameUi.setActive()
	map.setupMap()
	generateTasks()
	spawnEssentials()
	
	GameUi.Gametimer()

func generateTasks():
	var allTasks = Global.tasks
	
	var taskAmount = 80
	
	for i in taskAmount:
		var randT = randi_range(0, allTasks.size() - 1)
		
		var randTask = allTasks[randT]
		
		var foundPosition = false
		var pos: Vector2
		
		while !foundPosition:
			pos = Vector2(randi_range(1, Global.mapSize.x/tileSize - 2), randi_range(1, Global.mapSize.y/tileSize - 2)) * tileSize  
			foundPosition = true
			
			foundPosition = map.checkTile(pos)
			
			if foundPosition:
				for stat in stations:
					print(stat.global_position.distance_to(pos))
					if stat.global_position.distance_to(pos) < tileSize * 2:
						print("too close")
						foundPosition = false
		
		call(randTask, pos + Vector2(tileSize/2, tileSize/2))

func books(pos):
	var newBookshelf = bookShelf.instantiate()
	
	newBookshelf.global_position = pos
	
	add_child(newBookshelf)
	stations.append(newBookshelf)

func wires(pos):
	var newTaskStation = taskStation.instantiate()
	
	newTaskStation.interactTask = "wires"
	newTaskStation.global_position = pos
	
	add_child(newTaskStation)
	stations.append(newTaskStation)

func cleaning(pos):
	for i in randi_range(6, 8):
		var newPuddle = puddle.instantiate()
		newPuddle.global_position = pos
		add_child(newPuddle)
		stations.append(newPuddle)

func homework(pos):
	var newTaskStation = taskStation.instantiate()
	
	newTaskStation.interactTask = "mathHomework"
	newTaskStation.global_position = pos
	
	add_child(newTaskStation)
	stations.append(newTaskStation)

func poop(pos):
	for i in randi_range(8, 12):
		var foundPosition = false
		
		while !foundPosition:
			pos = Vector2(randi_range(tileSize, Global.mapSize.x), randi_range(tileSize, Global.mapSize.y)) 
			foundPosition = map.checkTile(pos)
		
		var newPoop = poopInstance.instantiate()
		newPoop.global_position = pos
		
		add_child(newPoop)

func coffee(pos):
	var newTaskStation = taskStation.instantiate()
	
	newTaskStation.interactTask = "coffeeTask"
	newTaskStation.global_position = pos
	
	add_child(newTaskStation)
	stations.append(newTaskStation)

func spawnEssentials():
	var foundPosition = false
	var pos: Vector2
		
	while !foundPosition:
		pos = Vector2(randi_range(1, Global.mapSize.x/tileSize - 2), randi_range(1, Global.mapSize.y/tileSize - 2)) * tileSize  
		foundPosition = true
		
		foundPosition = map.checkTile(pos)
		
		if foundPosition:
			for stat in stations:
				if stat.global_position.distance_to(pos) < tileSize * 2:
					foundPosition = false
	
	var newTrash = trashBin.instantiate()
	newTrash.global_position = pos
	add_child(newTrash)
	
	var broom = item.instantiate()
	broom.id = broomId
	broom.global_position = Vector2(randi_range(1, Global.mapSize.x/tileSize - 2), randi_range(1, Global.mapSize.y/tileSize - 2)) * tileSize  
	add_child(broom)
