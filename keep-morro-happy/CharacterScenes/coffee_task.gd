extends Control


var canPour = true
var pouring = false
@export var maxAmount: float = 100.0
var neededAmount: float = 100.0
var amount: float = 0.0
@export var pourSpeed: float = 50.0

var currentCup = null
var fill = null

@onready var container = $glassesContainer

func _process(_delta: float) -> void:
	if pouring and canPour:
		pour()

func _ready() -> void:
	nextCup()

func nextCup():
	amount = 0.0
	var newCup = ColorRect.new()
	var newFill = ColorRect.new()
	newFill.color = Color.SADDLE_BROWN
	newCup.add_child(newFill)
	newCup.size = Vector2(32, 64)
	newFill.size = Vector2(newCup.size.x, 0)
	container.add_child(newCup)
	newCup.global_position = container.global_position - Vector2(32, 0)
	
	var newTween = create_tween()
	newTween.tween_property(newCup, "global_position", Vector2(container.global_position.x - newCup.size.x/2 + container.size.x/2, newCup.global_position.y), 1)
	newTween.play()
	
	await newTween.finished
	
	currentCup = newCup
	fill = newFill
	
	canPour = true

func finishPouring():
	pouring = false
	var newTween = create_tween()
	newTween.tween_property(currentCup, "global_position", Vector2(container.global_position.x + container.size.x, currentCup.global_position.y), 1)
	newTween.play()
	
	await newTween.finished
	
	currentCup.queue_free()
	
	nextCup()

func pour():
	amount += pourSpeed
	print(pouring)
	fill.size = Vector2(fill.size.x, amount/maxAmount)
	fill.global_position.y = currentCup.global_position.y + currentCup.size.y - fill.size.y

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Throw") and !pouring and canPour:
		pouring = true
		
		while pouring:
			pour()
			await get_tree().create_timer(0.1).timeout
	
	if event.is_action_released("Throw") and pouring:
		finishPouring()

func _on_pour_button_button_down() -> void:
	if pouring or !canPour: return
	
	pouring = true
	while pouring:
		pour()
		await get_tree().create_timer(0.1).timeout

func _on_pour_button_button_up() -> void:
	finishPouring()
