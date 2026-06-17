extends Node2D


@onready var floorSize = $ColorRect.size
const floorTileArt = preload("res://Assets/Art/floorTile.png")
const floorTileAverage = preload("res://Assets/Art/floorTileBland.png")
@export var floorShader = preload("res://shaders/floorShader.gdshader")

@export var tileSize = 48

func _ready() -> void:
	var x = ceil(floorSize.x/tileSize)
	var y = ceil(floorSize.y/tileSize)
	
	createFloor(x, y)
	
	createWalls(x, y)

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

func createWalls(x, y):
	for i in 3:
		var randy = randi_range(0, y)
		var randSize = randi_range(x/5, x/1.5)
		
		var newWall = ColorRect.new()
		newWall.size = Vector2(randSize, 32)
		newWall.global_position = Vector2(0, randy)
		add_child(newWall)
	
