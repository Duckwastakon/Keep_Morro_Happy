extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.limit_right = Global.mapSize.x
	self.limit_bottom = Global.mapSize.y
