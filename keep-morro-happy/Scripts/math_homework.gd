extends Control

var types = ["+", "-", "*"]

var correctAnswers = 0
var answered = 0
@export var questionAmount = 5

@onready var questionClonable = $question
@onready var questionContainer = $questions
@onready var successIndicator = $successIndicator

var check = load("res://Assets/Art/check.png")
var cross = load("res://Assets/Art/cross.png")

var station

func _ready() -> void:
	generateQuestions()

func generateQuestions():
	correctAnswers = 0
	answered = 0
	
	for i in questionAmount:
		var newQuestion = questionClonable.duplicate()
		
		var ans = generateQuestion(newQuestion.get_child(1))
		
		var correct = randi_range(0, 3)
		
		var buttons = newQuestion.get_child(2).get_children()
		
		var n = 0
		for b in buttons:
			if n == correct:
				b.connect("button_up", answer.bind(buttons, n, true))
				b.get_child(0).clear()
				b.get_child(0).append_text("[color=white][outline_size=8]• " + str(ans))
			else:
				b.connect("button_down", answer.bind(buttons, n, false))
				b.get_child(0).clear()
				var extra = randi_range(-10 - ans, 10 + ans)
				while extra == 0:
					extra = randi_range(-10 - ans, 10 + ans)
				b.get_child(0).append_text("[color=white][outline_size=8]• " + str(ans + extra))
			
			n += 1
		var allChildSize = questionAmount * 64
		var allFreeSpace = questionContainer.size.y - allChildSize
		var freeSpaces = questionAmount + 1
		var freeSpace = allFreeSpace/freeSpaces
		
		questionContainer.add_child(newQuestion)
		newQuestion.position = Vector2(0, freeSpace * (i+1) + 64 * i)
		newQuestion.visible = true

func generateQuestion(newQuestion) -> int:
	var equationType = randi_range(0, 2)
	var answer: int
	var questionText: String
	if equationType == 0 or equationType == 1:
		var num1 = randi_range(0, 100)
		var num2 = randi_range(0, 100)
		
		if equationType == 0:
			answer = num1 + num2
		if equationType == 1:
			answer = num1 - num2
		
		questionText = str(num1) + " " + types[equationType] + " " + str(num2) + " = ?"
		newQuestion.text = questionText
	else:
		var num1 = randi_range(-9, 9)
		var num2 = randi_range(-9, 9)
		
		answer = num1 * (num2)
		
		questionText = str(num1) + " * " + str(num2) + " = ?"
		newQuestion.text = questionText
	
	
	
	return answer

func answer(buttons, id, correct):
	var i = 0
	for b in buttons:
		b.disabled = true
		var textLabel = b.get_child(0) 
		if i == id:
			if correct:
				var text = textLabel.get_parsed_text()
				textLabel.clear()
				textLabel.append_text("[color=green][outline_size=8]" + text)
				correctAnswers += 1
			else:
				var text = textLabel.get_parsed_text()
				textLabel.clear()
				textLabel.append_text("[color=red] [outline_size=8]" + text)
		else:
			var text = textLabel.get_parsed_text()
			textLabel.clear()
			textLabel.append_text("[s][color=white][outline_size=8]" + text)
		
		i+= 1
	
	answered += 1
	if correctAnswers >= questionAmount - 1 and answered >= questionAmount:
		successIndicator.texture = check
		successIndicator.visible = true
		
		get_parent().compleatedTask()
	elif answered >= questionAmount:
		successIndicator.texture = cross
		successIndicator.visible = true
		
		await get_tree().create_timer(1).timeout
		successIndicator.visible = false
		
		for c in questionContainer.get_children():
			c.queue_free()
		
		generateQuestions()
