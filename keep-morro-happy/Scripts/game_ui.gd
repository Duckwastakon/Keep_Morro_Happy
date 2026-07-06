extends CanvasLayer

var warnings = {
	"pets": "Morro wants to be pet"
}

@export var taskLabel: LabelSettings

var canCheck = false

@onready var happinessBar = $morroHappiness/barBackground/progress
@onready var warningContainer = $warnings/warningContainer
@onready var timerText = $dayTimer

@onready var dayTasks = $dayTasks
@onready var dayTasksContainer = $dayTasks/taskContainer

func setActive(val: bool):
	canCheck = val
	warnings.visible = val
	$morroHappiness.visible = val
	timerText.visible = val

func Gametimer():
	var timeLeft = Global.gameTime
	
	while timeLeft > 0:
		var mins = floor(timeLeft / 60)
		var secs = timeLeft - (mins * 60)
		
		if secs < 10:
			timerText.text = str(mins) + ":0" + str(secs)
		else:
			timerText.text = str(mins) + ":" + str(secs)
		
		await get_tree().create_timer(1).timeout
		timeLeft -= 1

func updateHappiness(happiness):
	var previousHappiness = happinessBar.scale.x * 100
	var size: float = clampf(float(happiness) / 100, 0, 100)
	var newTween = create_tween()
	newTween.tween_property(happinessBar, "scale", Vector2(size, 1), 0.1)
	newTween.play()
	
	var colorTween = create_tween()
	
	if previousHappiness > happiness:
		colorTween.tween_property(happinessBar, "color", Color(1,0.4,0.2,1), 0.05)
	else:
		colorTween.tween_property(happinessBar, "color", Color(0.7,1,0.2,1), 0.05)
	
	colorTween.play()
	await colorTween.finished
	
	colorTween.stop()
	colorTween.tween_property(happinessBar, "color", Color(1,0.9,0.2,1), 0.05)
	
	colorTween.play()

func addWarning(warning):
	var newWarning = Label.new()
	newWarning.text = warnings[warning]
	newWarning.name = warning
	
	warningContainer.add_child(newWarning)

func removeWarning(warning):
	var foundWarning = warningContainer.get_node(warning)
	
	if foundWarning:
		foundWarning.queue_free()

func addDayTask(text):
	var newText = Label.new()
	
	newText.text = text
	newText.modulate = Color.BLACK
	
	dayTasksContainer.add_child(newText)
	
	return newText

func _input(event: InputEvent) -> void:
	if !canCheck:
		return
	dayTasks.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if event.is_action_pressed("Q"):
		dayTasks.visible = true
	elif event.is_action_released("Q"):
		dayTasks.visible = false

func endGame(data) -> void:
	canCheck = false
	self.layer = 2
	for task in dayTasksContainer.get_children():
		task.visible = false
	
	$endGame.play("end")
	await $endGame.animation_finished
	
	setActive(false)
	
	get_tree().change_scene_to_file("res://Scenes/main_menue.tscn")
	
	var i = 0
	$outcomeText.text = "You Win"
	for task in dayTasksContainer.get_children():
		if data[i] == true:
			task.modulate = Color.LIME_GREEN
		else:
			task.modulate = Color.RED
			
			$outcomeText.text = "You Loose"
		i += 1
		
		task.visible = true
		await get_tree().create_timer(1).timeout
	$outcomeText.visible = true
	
	await get_tree().create_timer(1.5).timeout
	$Button.visible = true

func _on_button_button_down() -> void:
	$outcomeText.visible = false
	$Button.visible = false
	$endGame.play("openScene")
	self.layer = 0
	
	await $endGame.animation_finished
	
	for i in dayTasksContainer.get_children():
		i.queue_free()
	
