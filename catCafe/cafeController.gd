extends Node2D

@export var tileSize = 48
var rowSize = 1

var sittingLocations = []
var takenSittingLocations = []

func _ready() -> void:
	GameUi.openScreen()
	var tempArray = []
	var TilesIds = Global.mapData
	var x = -1
	var y = -1
	
	for array1 in TilesIds:
		tempArray.append([])
		for array2 in TilesIds[0].size():
			tempArray[array2].append(0)
	
	for row in TilesIds:
		y+=1
		x=-1
		for id in row:
			x+=1
			if id != -1:
				var newSprite: Sprite2D = Sprite2D.new()
				newSprite.texture = load(Global.buildings[id]["png"])
				newSprite.scale = Vector2(tileSize / 16, tileSize / 16)
				add_child(newSprite)
				newSprite.position = Vector2(x,y) * tileSize + Vector2(tileSize, tileSize) / 2
				if id==0:
					tempArray[y][x] -= 1
				if id==1:
					if tempArray[y].has(x-1):
						tempArray[y][x - 1] -= 1
					if tempArray[y].has(x+1):
						tempArray[y][x + 1] -= 1
					if(tempArray.has(y-1)):
						tempArray[y - 1][x] -= 1
					if(tempArray.has(y+1)):
						tempArray[y + 1][x] -= 1
	
	for valY in tempArray.size():
		for valX in tempArray[valY].size():
			if tempArray[valY][valX] == 1:
				pass
