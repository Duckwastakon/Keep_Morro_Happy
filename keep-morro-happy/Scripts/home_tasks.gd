extends CanvasLayer

var currentTask = null
var player

func openTask(task):
	if task:
		currentTask = task
		task.visible = true
		$closeTask.visible = true
		task.position = Vector2(0, 1000)
		var newTween = create_tween()
		newTween.tween_property(task, "position", Vector2(0, 0), 0.5)
		newTween.play()
		if player:
			player.canMove = false
		return true
	else: return false

func closeTask():
	if currentTask != null:
		var task = currentTask
		if task == null: return
		var newTween = create_tween()
		newTween.tween_property(task, "position", Vector2(0, 1000), 0.5)
		newTween.play()
		currentTask = null
		$closeTask.visible = false
		await newTween.finished
		if task == null: return
		task.visible = false
		if player:
			player.canMove = true

func compleatedTask():
	$CompleateText.visible = true
	currentTask.station.set_deferred("monitoring", false)
	currentTask.station.emit_signal("taskCompleated")
	
	await closeTask()
	$CompleateText.visible = false

func _on_close_task_button_up() -> void:
	closeTask()

func clearTasks():
	closeTask()
	
	for child in get_children():
		if child.name != "closeTask" and child.name != "CompleateText":
			print(child)
			child.queue_free()
