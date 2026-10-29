extends Container


func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		var allChildSize = get_child_count() * 64
		var allFreeSpace = size.y - allChildSize
		var freeSpaces = get_child_count() + 1
		var freeSpace = allFreeSpace/freeSpaces
		
		var i = 0
		for c in get_children():
			c.position = Vector2(0, freeSpace * (i+1) + 64 * i)
			c.size = Vector2(384, 64)
			i += 1
