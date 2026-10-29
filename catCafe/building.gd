extends Node2D

var tileObjects = []
var tileObjectIds = []

var rows = 5
var rowSize = 5

var selectedItemId = 0

@export var tileSize = 48
@onready var itemDisplay = $itemDisplay

var hoveredTile = Vector2(-1, -1)

func _ready() -> void:
	itemDisplay.scale = Vector2(tileSize/16, tileSize/16)
	equipItem(0)
	
	for y in rows:
		tileObjects.append([])
		tileObjectIds.append([])
		for x in rowSize:
			tileObjects[y].append(null)
			tileObjectIds[y].append(-1)

var itemPrefab = preload("uid://w7myu26r83mr")

func placeItem():
	if selectedItemId == -1 or itemDisplay.visible == false:
		return
	
	var selectedItemData = Global.buildings[selectedItemId]
	
	if Global.cash < selectedItemData["price"]:
		return
	
	Global.cash -= selectedItemData["price"]
	
	var newItem = itemPrefab.instantiate()
	newItem.scale = itemDisplay.scale
	add_child(newItem)
	newItem.position = hoveredTile * tileSize + Vector2(tileSize, tileSize) / 2
	newItem.get_child(1).texture = itemDisplay.texture
	tileObjects[hoveredTile.y][hoveredTile.x] = newItem
	tileObjectIds[hoveredTile.y][hoveredTile.x] = selectedItemId

func deleteItem():
	if tileObjects[hoveredTile.y][hoveredTile.x] != null:
		tileObjects[hoveredTile.y][hoveredTile.x].queue_free()
		tileObjects[hoveredTile.y][hoveredTile.x] = null
		Global.cash += Global.buildings[tileObjectIds[hoveredTile.y][hoveredTile.x]]["price"] / 2
		tileObjectIds[hoveredTile.y][hoveredTile.x] = -1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ThrowMouse"):
		placeItem()
	if event.is_action_pressed("rightClick"):
		deleteItem()

func _process(delta: float) -> void:
	var worldMousePos = get_global_mouse_position()
	hoveredTile = Vector2(floori(worldMousePos.x)/tileSize, floori(worldMousePos.y)/tileSize)
	print(hoveredTile)
	
	if hoveredTile.y > rows-1 or hoveredTile.x > rowSize-1:
		itemDisplay.visible = false
		return
	
	if tileObjects[hoveredTile.y][hoveredTile.x] != null:
		itemDisplay.visible = false
		return
	else:
		itemDisplay.visible = true
		itemDisplay.global_position = hoveredTile * tileSize + Vector2(tileSize, tileSize) / 2

func equipItem(id):
	selectedItemId = id
	var buildingData = Global.buildings[selectedItemId]
	itemDisplay.texture = load(buildingData["png"])

func _on_button_button_up() -> void:
	await GameUi.darkenScreen()
	Global.mapData = tileObjectIds
	get_tree().change_scene_to_file("uid://cfu1jg25k25ky")
