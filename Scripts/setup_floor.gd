extends Node2D


var floorSize = Global.difficulties[Global.difficulty].mapSize

const floorTileArt = preload("res://Assets/Art/floorTile.png")
const floorTileAverage = preload("res://Assets/Art/floorTileBland.png")
@export var floorShader = preload("res://shaders/floorShader.gdshader")

@export var roomAmount: int = 3

const tileSize = 32

var mapSize = Vector2.ZERO

@onready var floorTiles = $floor
@onready var wallTiles = $walls

func _ready() -> void:
	mapSize = Global.difficulties[Global.difficulty].mapSize

func setupMap() -> void:
	floorTiles.scale = Vector2(tileSize/16, tileSize/16)
	wallTiles.scale = Vector2(tileSize/16, tileSize/16)
	
	var x = ceil(floorSize.x/tileSize)
	var y = ceil(floorSize.y/tileSize)
	
	createFloor(x, y)
	
	createRooms()
	
	createSuroundingWalls()
	updateWallSprites()

func createFloor(x, y):
	var offset = Vector2(tileSize/2, tileSize/2)
	var newNavigationSurface = NavigationRegion2D.new()
	add_child(newNavigationSurface)
	
	for i in x:
		for n in y:
			var global_pos = offset + Vector2(tileSize*i, tileSize*n)
			var pos = floorTiles.local_to_map(floorTiles.to_local(global_pos))
			floorTiles.set_cell(pos, 0, Vector2i(0, 0))
			
			if randi_range(0,9) <= 2:
				floorTiles.set_cell(pos, 0, Vector2i(randi_range(0, 5), 0))

func createSuroundingWalls():
	for x in 2:
		var wallSize = Vector2(mapSize.x, tileSize) + Vector2(tileSize, 0)
		var wallPos = Vector2(0, mapSize.y * x) + Vector2(tileSize, tileSize) * (x - 1)
		createWall(wallSize, wallPos)
	for y in 2:
		var wallSize = Vector2(tileSize, mapSize.y) + Vector2(0, tileSize)
		var wallPos = Vector2(mapSize.x * y, 0) + Vector2(tileSize, tileSize) * (y - 1)
		
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
	var startTilePos = wallTiles.local_to_map(wallTiles.to_local(pos))
	
	if(size.x >= size.y):
		for i in size.x/tileSize:
			wallTiles.set_cell(startTilePos + Vector2i(i, 0), 0, Vector2i(6, 0))
			floorTiles.erase_cell(startTilePos + Vector2i(i, 0))
	else:
		for i in size.y/tileSize:
			wallTiles.set_cell(startTilePos + Vector2i(0, i), 0, Vector2i(6, 0))
			floorTiles.erase_cell(startTilePos + Vector2i(0, i))

func checkTile(pos) -> bool:
	var data = floorTiles.get_cell_tile_data(floorTiles.local_to_map(floorTiles.to_local(pos)))
	
	if data:
		return true
	
	return false

var tilei = {
	"[0, 0, 0, 0]" = 6,
	"[0, 0, 1, 0]" = 7,
	"[1, 0, 0, 0]" = 8,
	"[0, 1, 0, 0]" = 9,
	"[0, 0, 0, 1]" = 10,
	"[0, 1, 0, 1]" = 11,
	"[1, 0, 1, 0]" = 12,
	"[1, 1, 0, 0]" = 13,
	"[0, 1, 1, 0]" = 14,
	"[0, 0, 1, 1]" = 15,
	"[1, 0, 0, 1]" = 16,
	"[1, 0, 1, 1]" = 17,
	"[1, 1, 0, 1]" = 18,
	"[1, 1, 1, 0]" = 19,
	"[0, 1, 1, 1]" = 20,
	"[1, 1, 1, 1]" = 21,
}


func updateWallSprites():
	for x in mapSize.x/tileSize:
		for y in mapSize.y/tileSize:
			if wallTiles.get_cell_tile_data(Vector2i(x, y)):
				var surrounding = [0, 0, 0, 0]
				
				if wallTiles.get_cell_tile_data(Vector2i(x - 1, y)):
					surrounding[0] = 1
				if wallTiles.get_cell_tile_data(Vector2i(x, y - 1)):
					surrounding[1] = 1
				if wallTiles.get_cell_tile_data(Vector2i(x + 1, y)):
					surrounding[2] = 1
				if wallTiles.get_cell_tile_data(Vector2i(x, y + 1)):
					surrounding[3] = 1
				
				wallTiles.set_cell(Vector2i(x, y), 0, Vector2i(tilei[str(surrounding)], 0))
