extends Node2D


@onready var floorSize = $ColorRect.size
const floorTileArt = preload("res://Assets/Art/floorTile.png")
const floorTileAverage = preload("res://Assets/Art/floorTileBland.png")
@export var floorShader = preload("res://shaders/floorShader.gdshader")

@export var roomAmount: int = 3

@export var tileSize = 48

func _ready() -> void:
	var x = ceil(floorSize.x/tileSize)
	var y = ceil(floorSize.y/tileSize)
	
	createFloor(x, y)
	
	createRooms()

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
	
	var doorSize = randi_range(2, 4) * tileSize
	var doorSize2 = randi_range(2, 4) * tileSize
	
	var randDoorSpot1 = randi_range(1, randi_range(1, room1Size.x/tileSize)) * tileSize - doorSize
	var randDoorSpot2 = randi_range(1, randi_range(1, room2Size.x/tileSize) * tileSize - doorSize)
	
	var wall1 = ColorRect.new()
	var wall2 = ColorRect.new()
	
	wall1.size = Vector2(randDoorSpot1, 32)
	wall1.global_position = room1.global_position
	wall1.z_index = 5
	
	wall2.size = Vector2(room1Size.x - (doorSize + wall1.size.x), 32)
	wall2.global_position = room1.global_position + Vector2(wall1.size.x + doorSize, 0)
	wall2.z_index = 5
	
	add_child(wall1)
	add_child(wall2)
