extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.limit_right = Global.mapSize.x
	self.limit_bottom = Global.mapSize.y

func screenshake(Strength: int = 5, length: float = 0.2):
	Strength = Strength / 100 * Global.screenShake
	
	while length>0:
		var newTween = create_tween()
		var randSpeed = randf_range(0.05, 0.1)
		newTween.tween_property(self, "offset", Vector2(randi_range(-Strength, Strength), randi_range(-Strength, Strength)), randSpeed)
		
		newTween.play()
		await newTween.finished
		
		length -= randSpeed
	var newTween = create_tween()
	newTween.tween_property(self, "offset", Vector2.ZERO, 0.1)
	
	newTween.play()
