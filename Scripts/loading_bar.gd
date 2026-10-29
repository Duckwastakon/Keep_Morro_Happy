extends Node2D

var newTween = null

func fire(time):
	if newTween != null:
		newTween.stop()
	$Background/Fill.scale = Vector2(0, 1)
	visible = true
	
	newTween = create_tween()
	newTween.tween_property($Background/Fill, "scale", Vector2(1, 1), time)
	newTween.play()
	await newTween.finished
	visible = false
