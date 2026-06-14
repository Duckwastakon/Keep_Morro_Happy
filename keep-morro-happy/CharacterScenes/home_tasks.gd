extends CanvasLayer

var currentTask = "mathHomework"

func _input(event: InputEvent) -> void:
	pass
	#if event.is_action_released("Throw") and currentTask != null:
	#	closeTask()

func openTask(Task):
	var task = get_node(Task)
	if task:
		currentTask = Task
		task.visible = true
		$closeTask.visible = true
		task.position = Vector2(0, 1000)
		var newTween = create_tween()
		newTween.tween_property(task, "position", Vector2(0, 0), 0.5)
		newTween.play()
		if get_parent().name == "player":
			get_parent().canMove = false
		return true
	else: return false

func closeTask():
	if currentTask != null:
		var task = get_node(currentTask)
		var newTween = create_tween()
		newTween.tween_property(task, "position", Vector2(0, 1000), 0.5)
		newTween.play()
		currentTask = null
		$closeTask.visible = false
		await newTween.finished
		task.visible = false
		if get_parent().name == "player":
			get_parent().canMove = true

func compleatedTask():
	$CompleateText.visible = true
	await closeTask()
	$CompleateText.visible = false

func _on_close_task_button_up() -> void:
	closeTask()
