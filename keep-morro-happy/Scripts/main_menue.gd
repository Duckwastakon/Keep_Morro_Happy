extends Control

@onready var levelButtons = $levelButtons
@onready var selectionButtons = $selectionButtons
@onready var settingSliders = $settingsSliders

var currentControll = null
var selectedLevel = null

var midPos = Vector2.ZERO

func _ready() -> void:
	GameUi.playMusic(load("res://Assets/Music/menuMusic.mp3"))
	midPos = selectionButtons.global_position
	for btn in levelButtons.get_children():
		if btn is Button:
			btn.connect("mouse_entered", selectButton.bind(btn, true, btn.get_child(0).text))
			btn.connect("mouse_exited", selectButton.bind(btn, false, btn.get_child(0).text))
			if btn.name != "back":
				btn.connect("button_up", loadLevel.bind(btn.name))
			else:
				btn.connect("button_up", back)
	
	for btn in selectionButtons.get_children():
			btn.connect("mouse_entered", selectButton.bind(btn, true, btn.get_child(0).text))
			btn.connect("mouse_exited", selectButton.bind(btn, false, btn.get_child(0).text))
			
			var cfun = Callable(self, btn.name)
			btn.connect("button_up", cfun)

func loadLevel(level):
	Global.difficulty = level
	ExtraVisuals.playSound(load("res://Assets/Music/select.mp3"), Vector2.ZERO)
	await  get_tree().create_timer(0.2).timeout
	await GameUi.darkenScreen()
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Throw") and selectedLevel != null:
		loadLevel(selectedLevel)

func selectButton(btn, val, text):
	if val:
		selectedLevel = btn.name
		btn.get_child(0).clear()
		btn.get_child(0).parse_bbcode("[wobbly dim=1 freq=10 wave=100 amp=2.5]" + text + "[wobbly]")
	else:
		if selectedLevel == btn.name:
			selectedLevel = null
		
		btn.get_child(0).clear()
		btn.get_child(0).parse_bbcode("[wobbly]" + text + "[wobbly]")

func play():
	levelButtons.global_position = midPos + Vector2(0, 500)
	levelButtons.visible = true
	
	var newTween = create_tween()
	newTween.tween_property(levelButtons, "global_position", midPos, 0.5)
	var newTween2 = create_tween()
	newTween2.tween_property(selectionButtons, "global_position", midPos + Vector2(0, 500), 0.5)
	
	newTween.play()
	newTween2.play()
	
	await newTween2.finished
	
	currentControll = levelButtons
	
	selectionButtons.visible = false

func tutorial():
	$tutorial.visible = true

func settings():
	settingSliders.global_position = midPos + Vector2(0, 500)
	settingSliders.visible = true
	
	var newTween = create_tween()
	newTween.tween_property(settingSliders, "global_position", midPos, 0.5)
	var newTween2 = create_tween()
	newTween2.tween_property(selectionButtons, "global_position", midPos + Vector2(0, 500), 0.5)
	
	newTween.play()
	newTween2.play()
	
	await newTween2.finished
	
	currentControll = settingSliders
	
	selectionButtons.visible = false

func exit():
	get_tree().quit()

func back():
	selectionButtons.global_position = midPos + Vector2(0, 500)
	selectionButtons.visible = true
	
	var newTween = create_tween()
	newTween.tween_property(selectionButtons, "global_position", midPos, 0.5)
	var newTween2 = create_tween()
	newTween2.tween_property(currentControll, "global_position", midPos + Vector2(0, 500), 0.5)
	
	newTween.play()
	newTween2.play()
	
	await newTween2.finished
	
	currentControll.visible = false

func _on_back_button_down() -> void:
	back()
