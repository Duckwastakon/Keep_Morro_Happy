extends Node2D


func fire(time):
	$Background/Fill.scale = Vector2(0, 1)
	visible = true
	var newTween = create_tween()
	newTween.tween_property($Background/Fill, "scale", Vector2(1, 1), time)
	newTween.play()
	await newTween.finished
	visible = false
