extends Node2D


var floorSize = Global.mapSize

const floorTileArt = preload("res://Assets/Art/floorTile.png")
const floorTileAverage = preload("res://Assets/Art/floorTileBland.png")
@export var floorShader = preload("res://shaders/floorShader.gdshader")

@export var roomAmount: int = 3

const tileSize = 48

func _ready() -> void:
	var x = ceil(floorSize.x/tileSize)
	var y = ceil(floorSize.y/tileSize)
	
	createFloor(x, y)
	
	createRooms()
	
	createSuroundingWalls()

func createFloor(x, y):
	var offset = Vector2(tileSize/2, tileSize/2)
	
	for i in x:
		for n in y:
			var newTile = Sprite2D.new()
			newTile.texture = floorTileAverage
			newTile.scale = Vector2(tileSize / 16, tileSize / 16)
			newTile.global_position = offset + Vector2(tileSize*i, tileSize*n)
			
			if randi_range(0,9) <= 1:
				var aboveTile = Sprite2D.new()
				newTile.add_child(aboveTile)
				aboveTile.global_position = newTile.global_position
				aboveTile.texture = floorTileArt
				var newShaderMaterial = ShaderMaterial.new()
				newShaderMaterial.shader = floorShader
				aboveTile.material = newShaderMaterial
			
			add_child(newTile)

func createSuroundingWalls():
	for x in 2:
		for y in 2:
			var newWall = ColorRect.new()
			newWall.size = floorSize * Vector2(x, y)
			newWall.size.x = clamp(newWall.size.x, tileSize, floorSize.x)
			newWall.size.y = clamp(newWall.size.y, tileSize, floorSize.y)
			newWall.position = floorSize * Vector2(x, y)
			
			add_child(newWall)

func createRooms():
	var length = floorSize.y
	var width = floorSize.x
	
	var minRoomWidth = width/roomAmount/tileSize
	var minRoomLength = length/roomAmount/tileSize
	var maxRoomWidth = width/roomAmount*2/tileSize
	var maxRoomLength = length/roomAmount*2/tileSize
	
	var room1Size = Vector2(randi_range(minRoomWidth, maxRoomWidth) * tileSize, randi_range(minRoomLength, maxRoomLength) * tileSize)
	var room2Size = Vector2(width - room1Size.x, randi_range(minRoomLength, maxRoomLength) * tileSize)
	
	var room1 = ColorRect.new()
	room1.modulate = Color.RED
	room1.size = room1Size
	
	var room2 = ColorRect.new()
	room2.modulate = Color.BLUE
	room2.size = room2Size
	
	room1.global_position = Vector2(width - room1Size.x, length - room1Size.y)
	room2.global_position = Vector2(0, length - room2Size.y)
	
	room1.z_index = 3
	room2.z_index = 3
	add_child(room1)
	add_child(room2)
	
	var doorSize = randi_range(round(room1Size.x/tileSize/5), round(room1Size.x/tileSize/2)) * tileSize
	var doorSize2 = randi_range(round(room2Size.x/tileSize/5), round(room2Size.x/tileSize/2)) * tileSize
	
	var randDoorSpot1 = randi_range(1, room1Size.x/tileSize-2) * tileSize
	var randDoorSpot2 = randi_range(1, room2Size.x/tileSize-2) * tileSize
	
	var wall1 = ColorRect.new()
	var wall2 = ColorRect.new()
	
	wall1.size = Vector2(randDoorSpot1, tileSize)
	wall1.global_position = room1.global_position
	wall1.z_index = 5
	
	wall2.size = Vector2(room1Size.x - (doorSize + wall1.size.x), tileSize)
	wall2.global_position = room1.global_position + Vector2(wall1.size.x + doorSize, 0)
	wall2.z_index = 5
	
	add_child(wall1)
	add_child(wall2)
	
	var wall3 = ColorRect.new()
	var wall4 = ColorRect.new()
	
	wall3.size = Vector2(randDoorSpot2, tileSize)
	wall3.global_position = room2.global_position
	wall3.z_index = 5
	
	wall4.size = Vector2(room2Size.x - (doorSize2 + wall3.size.x), tileSize)
	wall4.global_position = room2.global_position + Vector2(wall3.size.x + doorSize2, 0)
	wall4.z_index = 5
	
	var wall5 = ColorRect.new()
	wall5.z_index = 5
	
	if room1Size.y > room2.size.y:
		wall5.size = Vector2(tileSize, room1.size.y)
		wall5.global_position = room1.global_position
	else:
		wall5.size = Vector2(tileSize, room2.size.y)
		wall5.global_position = room2.global_position + Vector2(room2.size.x, 0)
	
	add_child(wall3)
	add_child(wall4)
	add_child(wall5)

func createDoorWall(size, pos):
	var doorSize
	var doorSpot
	
	if size.x > size.y:
		doorSize = Vector2(randi_range(round(size.x/tileSize/5), round(size.x/tileSize/2)) * tileSize, tileSize)
		doorSpot = Vector2(randi_range(1, size.x/tileSize-2) * tileSize, 0)
	else:
		doorSize = Vector2(tileSize, randi_range(round(size.y/tileSize/5), round(size.y/tileSize/2)) * tileSize)
		doorSpot = Vector2(0, randi_range(1, size.y/tileSize-2) * tileSize)
	
	createWall(doorSpot, pos)
	createWall(size - doorSize - doorSpot, pos + doorSpot + doorSize)

func createWall(size, pos):
	var wall = ColorRect.new()
	
	wall.size = size
	wall.global_position = pos
	wall.z_index = 5
	
	add_child(wall)
	
	pass
	var newStaticBody = StaticBody2D.new()
	var newCollision = CollisionShape2D.new()
	
	newCollision.shape = RectangleShape2D.new()
	newCollision.shape.size = size
	newStaticBody.add_child(newCollision)
	newStaticBody.global_position = pos + pos / 2
	newCollision.position = Vector2.ZERO
	add_child(newStaticBody)
