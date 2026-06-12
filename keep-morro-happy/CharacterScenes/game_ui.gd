extends CanvasLayer

@onready var happinessBar = $morroHappiness/barBackground/progress

func updateHappiness(happiness):
	var size: float = clampf(float(happiness) / 100, 0, 100)
	var newTween = create_tween()
	newTween.tween_property(happinessBar, "scale", Vector2(size, 1), 0.1)
	newTween.play()
