extends CanvasLayer

@onready var spriteRender = $inventoryBackground/itemSprite
@onready var itemName = $itemName

func grabItem(id):
	var item = Global.Items[id]
	spriteRender.visible = true
	spriteRender.texture = load(item.sprite)
	itemName.text = item.name

func dropItem():
	spriteRender.visible = false
	itemName.text = "Empty"
