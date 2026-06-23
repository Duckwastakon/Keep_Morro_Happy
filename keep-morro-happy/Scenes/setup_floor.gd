extends Node2D


var floorSize = Global.mapSize

const floorTileArt = preload("res://Assets/Art/floorTile.png")
const floorTileAverage = preload("res://Assets/Art/floorTileBland.png")
@export var floorShader = preload("res://shaders/floorShader.gdshader")

@export var roomAmount: int = 3

const tileSize = 48

@onready var floorTiles = $floor
@onready var wallTiles = $walls

func _ready() -> void:
	floorTiles.scale = Vector2(tileSize/16, tileSize/16)
	wallTiles.scale = Vector2(tileSize/16, tileSize/16)
	
	var x = ceil(floorSize.x/tileSize)
	var y = ceil(floorSize.y/tileSize)
	
	createFloor(x, y)
	
	createRooms()
	
	createSuroundingWalls()

func createFloor(x, y):
	var offset = Vector2(tileSize/2, tileSize/2)
	var newNavigationSurface = NavigationRegion2D.new()
	add_child(newNavigationSurface)
	
	for i in x:
		for n in y:
			#var newTile = Sprite2D.new()
			#newTile.texture = floorTileAverage
			#newTile.scale = Vector2(tileSize / 16, tileSize / 16)
			var global_pos = offset + Vector2(tileSize*i, tileSize*n)
			var pos = floorTiles.local_to_map(floorTiles.to_local(global_pos))
			floorTiles.set_cell(pos, 0, Vector2i(0, 0))
			
			if randi_range(0,9) <= 1:
				var aboveTile = Sprite2D.new()
				add_child(aboveTile)
				aboveTile.z_index = 1
				aboveTile.scale = Vector2(tileSize/16, tileSize/16)
				aboveTile.global_position = global_pos
				aboveTile.texture = floorTileArt
				var newShaderMaterial = ShaderMaterial.new()
				newShaderMaterial.shader = floorShader
				aboveTile.material = newShaderMaterial

func createSuroundingWalls():
	for x in 2:
		var wallSize = Vector2(Global.mapSize.x, tileSize) + Vector2(tileSize, 0)
		var wallPos = Vector2(0, Global.mapSize.y * x) + Vector2(tileSize, tileSize) * (x - 1)
		createWall(wallSize, wallPos)
	for y in 2:
		var wallSize = Vector2(tileSize, Global.mapSize.y) + Vector2(0, tileSize)
		var wallPos = Vector2(Global.mapSize.x * y, 0) + Vector2(tileSize, tileSize) * (y - 1)
		
		createWall(wallSize, wallPos)

func createRooms():
	var length = floorSize.y
	var width = floorSize.x
	
	var minRoomWidth = width/roomAmount/tileSize
	var minRoomLength = length/roomAmount/tileSize
	var maxRoomWidth = width/roomAmount*2/tileSize
	var maxRoomLength = length/roomAmount*2/tileSize
	
	var room1Size = Vector2(randi_range(minRoomWidth, maxRoomWidth) * tileSize, randi_range(minRoomLength, maxRoomLength) * tileSize)
	var room2Size = Vector2(width - room1Size.x, randi_range(minRoomLength, maxRoomLength) * tileSize)
	
	createDoorWall(room1Size, Vector2(width - room1Size.x, length - room1Size.y), false)
	createDoorWall(room2Size, Vector2(0, length - room2Size.y), false)
	
	if room1Size.y > room2Size.y:
		createWall(Vector2(tileSize, room1Size.y - room2Size.y), Vector2(width - room1Size.x, length - room1Size.y))
		createDoorWall(room2Size, Vector2(0, length - room2Size.y) + Vector2(room2Size.x, 0), true)
	else:
		createWall(Vector2(tileSize, room2Size.y - room1Size.y), Vector2(0, length - room2Size.y) + Vector2(room2Size.x, 0))
		createDoorWall(room1Size, Vector2(width - room1Size.x, length - room1Size.y), true)

func createDoorWall(size, pos, middle = false):
	var doorSize
	var doorSpot
	var wall2Size
	var wall2Pos
	
	if !middle:
		doorSize = Vector2(randi_range(round(size.x/tileSize/5), round(size.x/tileSize/2)) * tileSize, tileSize)
		doorSpot = Vector2(randi_range(1, size.x/tileSize/2-1) * tileSize, tileSize)
		wall2Size = Vector2(size.x - doorSize.x - doorSpot.x, tileSize)
		wall2Pos = pos + Vector2(doorSpot.x + doorSize.x, 0)
	else:
		doorSize = Vector2(tileSize, randi_range(round(size.y/tileSize/5), round(size.y/tileSize/2)) * tileSize)
		doorSpot = Vector2(tileSize, randi_range(1, size.y/tileSize/2-1) * tileSize)
		wall2Size = Vector2(tileSize, size.y - doorSize.y - doorSpot.y)
		wall2Pos = pos + Vector2(0, doorSpot.y + doorSize.y)
	
	createWall(doorSpot, pos)
	createWall(wall2Size, wall2Pos)

func createWall(size, pos):
	var wall = ColorRect.new()
	
	wall.size = size
	wall.global_position = pos
	wall.z_index = 5
	
	var startTilePos = wallTiles.local_to_map(wallTiles.to_local(pos))
	
	if(size.x >= size.y):
		for i in size.x/tileSize:
			wallTiles.set_cell(startTilePos + Vector2i(i, 0), 0, Vector2i(6, 0))
			floorTiles.erase_cell(startTilePos + Vector2i(i, 0))
	else:
		for i in size.y/tileSize:
			wallTiles.set_cell(startTilePos + Vector2i(0, i), 0, Vector2i(6, 0))
			floorTiles.erase_cell(startTilePos + Vector2i(0, i))
	
	var newStaticBody = StaticBody2D.new()
	wall.add_child(newStaticBody)
	
	var newCollision = CollisionShape2D.new()
	newStaticBody.add_child(newCollision)
	newCollision.shape = RectangleShape2D.new()
	newCollision.shape.size = size
	newStaticBody.global_position = pos + size/2
	newCollision.position = Vector2.ZERO
	
	var newNavigationObject = NavigationObstacle2D.new()
	newStaticBody.add_child(newNavigationObject)
	newNavigationObject.vertices.append_array([Vector2.ZERO, Vector2(0, size.y), Vector2(size.x, size.y), Vector2(size.x, 0)])
