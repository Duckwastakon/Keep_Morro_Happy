extends Node

var infoTextLabel = preload("res://CharacterScenes/interaction_information.tscn")
func floatingText(text, pos):
	var newText = Label.new()
	
	newText.text = text
	pos = pos + Vector2(randi_range(-10, 10), randi_range(-10, 10)) - newText.size/2
	newText.global_position = pos
	
	get_tree().current_scene.add_child(newText)
	var newTween = create_tween()
	newTween.tween_property(newText, "global_position", 
	pos + Vector2(randi_range(-20, 20), randi_range(-10, -100)), 1)
	newTween.play()
	await newTween.finished
	
	newText.queue_free()

func loadInfo(requestingNode, text, offset = Vector2(0, 32)) -> RichTextLabel:
	var newText = infoTextLabel.instantiate()
	newText.setText(text)
	requestingNode.add_child(newText)
	newText.global_position = requestingNode.global_position + offset - newText.size/2
	
	return newText

func floatingSprite(sprite, pos):
	var newSprite = Sprite2D.new()
	
	newSprite.texture = sprite
	newSprite.z_index = 10
	newSprite.scale = Vector2(0, 0)
	pos = pos + Vector2(randi_range(-24, 24), randi_range(-24, 24))
	newSprite.global_position = pos
	
	get_tree().current_scene.add_child(newSprite)
	var scaleTween = create_tween()
	scaleTween.tween_property(newSprite, "scale", Vector2(1,1), 0.05)
	scaleTween.play()
	await scaleTween.finished
	
	var newTween = create_tween()
	scaleTween.stop()
	scaleTween.tween_property(newSprite, "scale", Vector2(0,0), 1)
	newTween.tween_property(newSprite, "global_position", 
	pos + Vector2(randi_range(-20, 20), randi_range(-10, -100)), 1)
	newTween.play()
	scaleTween.play()
	await newTween.finished
	
	newSprite.queue_free()
