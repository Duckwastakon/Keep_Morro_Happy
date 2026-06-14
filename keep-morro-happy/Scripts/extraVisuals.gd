extends Node

func floatingText(text, pos):
	pos += Vector2(randi_range(-10, 10), randi_range(-10, 10))
	var newText = Label.new()
	
	newText.text = text
	newText.global_position = pos
	
	get_tree().current_scene.add_child(newText)
	var newTween = create_tween()
	newTween.tween_property(newText, "global_position", 
	pos + Vector2(randi_range(-20, 20), randi_range(-10, -100)), 1)
	newTween.play()
	await newTween.finished
	
	newText.queue_free()
