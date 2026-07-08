extends CanvasLayer

var warnings = {
	"pets": "Morro wants pets!",
	"food": "Morro is hungry!"
}

@export var taskLabel: LabelSettings

var canCheck = false

var warningActive = false

@onready var warnMain = $Warning
@onready var warningText = $Warning/Label
@onready var fill = $Warning/background/fill
@onready var fillBackground = $Warning/background
@onready var warningTimer = $Warning/warningTimer

@onready var timerText = $dayTimer

@onready var dayTasks = $dayTasks
@onready var dayTasksContainer = $dayTasks/taskContainer

func setActive(val: bool):
	canCheck = val
	warnings.visible = val
	timerText.visible = val

func Gametimer():
	var timeLeft = Global.difficulties[Global.difficulty].gameTime
	
	while timeLeft > 0:
		var mins = floor(timeLeft / 60)
		var secs = timeLeft - (mins * 60)
		
		if secs < 10:
			timerText.text = str(mins) + ":0" + str(secs)
		else:
			timerText.text = str(mins) + ":" + str(secs)
		
		await get_tree().create_timer(1).timeout
		timeLeft -= 1

func addWarning(warning) -> bool:
	if warningActive: return false
	
	warningActive = true
	warnMain.visible = true
	warningText.text = warnings[warning]
	fill.scale = Vector2(1, 1)
	fill.color = Color(1,1,1,1)
	var newTween = create_tween()
	newTween.tween_property(fill, "scale", Vector2(0, 1), 10)
	var newTween2 = create_tween()
	newTween2.tween_property(fill, "color", Color(1, 0.2, 0, 1), 10)
	newTween.play()
	newTween2.play()
	
	warningTimer.start(10)
	
	return true

func removeWarning(warning):
	if warningText.text != warnings[warning]: return
	
	if warningActive:
		warnMain.visible = false
		warningActive = false
		warningTimer.stop()

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

func endGame(gottenData) -> void:
	tasks.clearTasks()
	var data = []
	for i in gottenData:
		data.append(i)
	
	var outcome = true
	
	var i = 0
	for task in dayTasksContainer.get_children():
		if data[i] == true:
			task.modulate = Color.LIME_GREEN
		else:
			task.modulate = Color.RED
			outcome = false
		i += 1
	
	canCheck = false
	self.layer = 2
	for task in dayTasksContainer.get_children():
		task.visible = false
	
	$endGame.play("end")
	await $endGame.animation_finished
	
	setActive(false)
	
	get_tree().change_scene_to_file("res://Scenes/main_menue.tscn")
	await get_tree().create_timer(0.2).timeout
	
	i = 0
	for task in dayTasksContainer.get_children():
		if data[i] == true:
			task.modulate = Color.LIME_GREEN
		else:
			task.modulate = Color.RED
			outcome = false
		i += 1
	
	if outcome:
		$outcomeText.text = "You Win"
	else:
		$outcomeText.text = "You Loose"
	
	for task in dayTasksContainer.get_children():
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

func darkenScreen():
	$endGame.play("close")
	await $endGame.animation_finished

func openScreen():
	$endGame.play("open")
