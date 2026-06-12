extends CanvasLayer

@onready var spriteRender = $inventoryBackground/itemSprite
@onready var itemName = $itemName

func grabItem(id):
	var item = Global.Items[id]
	spriteRender.color = item.sprite
	itemName.text = item.name

func dropItem():
	spriteRender.color = Color8(255, 255, 255, 0)
	itemName.text = "Empty"
