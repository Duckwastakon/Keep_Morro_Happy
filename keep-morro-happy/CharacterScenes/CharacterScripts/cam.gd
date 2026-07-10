extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.limit_right = Global.difficulties[Global.difficulty].mapSize.x
	self.limit_bottom = Global.difficulties[Global.difficulty].mapSize.y

func screenshake(Strength: float = 5.0, length: float = 0.2):
	print(Global.screenShake)
	print(Strength / 100)
	Strength = (Strength / 100) * Global.screenShake * 4
	print((Strength / 100) * Global.screenShake)
	
	while length>0:
		var newTween = create_tween()
		var randSpeed = randf_range(0.01, 0.03)
		newTween.tween_property(self, "offset", Vector2(randf_range(-Strength, Strength), randf_range(-Strength, Strength)), randSpeed)
		
		newTween.play()
		await newTween.finished
		
		length -= randSpeed
	var newTween = create_tween()
	newTween.tween_property(self, "offset", Vector2.ZERO, 0.1)
	
	newTween.play()
