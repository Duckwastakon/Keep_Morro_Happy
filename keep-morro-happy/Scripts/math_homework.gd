extends Control

var types = ["+", "-", "*"]

var answer = null
var questionText = null

var answeredCorrect = 0
@onready var infoText = $info

var station

func _ready() -> void:
	generateQuestion()

func generateQuestion():
	var equationType = randi_range(0, 2)
	if equationType == 0 or equationType == 1:
		var num1 = randi_range(-500, 500)
		var num2 = randi_range(-500, 500)
		
		if equationType == 0:
			answer = num1 + num2
		if equationType == 1:
			answer = num1 - num2
		
		questionText = str(num1) + " " + types[equationType] + " " + str(num2) + " = ?"
	else:
		var num1 = randi_range(-10, 10)
		var num2 = randi_range(-10, 10)
		
		answer = num1 * (num2)
		
		questionText = str(num1) + " * " + str(num2) + " = ?"
	
	$question.text = questionText
	var correctAnswer = randi_range(0, 3)
	
	for i in 4:
		var newAnswer = Button.new()
		if i == correctAnswer:
			newAnswer.text = "• " + str(answer)
			newAnswer.button_down.connect(answerQuestion.bind(true))
		else:
			var rand = randi_range(-50, 50)
			while rand == 0:
				rand = randi_range(-50, 50)
			newAnswer.text = "• " + str(answer + rand)
			newAnswer.button_down.connect(answerQuestion.bind(false))
		$answers.add_child(newAnswer)

func answerQuestion(correct):
	if correct:
		answeredCorrect += 1
		
		infoText.text = "Correct"
		infoText.add_theme_color_override("font_color", Color.GREEN)
		infoText.visible = true
		await get_tree().create_timer(1).timeout
		
		infoText.visible = false
	else:
		infoText.text = "X"
		infoText.add_theme_color_override("font_color", Color.RED)
		infoText.visible = true
		await get_tree().create_timer(1).timeout
		
		infoText.visible = false
	if answeredCorrect >= 5:
		get_parent().compleatedTask()
		return
	
	for i in $answers.get_children():
		i.queue_free()
	
	generateQuestion()
