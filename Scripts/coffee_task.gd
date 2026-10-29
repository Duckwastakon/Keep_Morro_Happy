extends Control


var canPour = true
var pouring = false
const maxAmount: float = 100.0
var neededAmount: float = 100.0
var amount: float = 0.0

var cirlceSprite = preload("res://Assets/Art/circle.png")
var checkmark = preload("res://Assets/Art/check.png")
var cross = preload("res://Assets/Art/cross.png")

@export var pourSpeed: float = 0.5
@onready var spillParticles = $CoffeeMug/spillParticles
var neededCups = randi_range(2, 5)
var gottenCups = 0

@onready var cup = $CoffeeMug
@onready var fill = $CoffeeMug/fill
@onready var indicator = $CoffeeMug/indicator
@onready var cupCounter = $cupCounter
@onready var particlePos = $CoffeeMug/particleSpawnPoint
@onready var successIndicator = $successIndiator

var station

@onready var conveyor = $conveyorBelt/ColorRect

var coffeeSprite = preload("res://Assets/Art/coffeeMug.png")

func _process(_delta: float) -> void:
	if pouring and canPour:
		pour()

func _ready() -> void:
	cupCounter.text = "0/" + str(neededCups)
	nextCup()

func nextCup():
	canPour = false
	amount = 0.0
	cup.global_position = conveyor.global_position + Vector2(32, 0)
	fill.scale = Vector2(1,0)
	
	var newTween = create_tween()
	newTween.tween_property(cup, "global_position", Vector2(conveyor.global_position.x + conveyor.size.x/2, cup.global_position.y), 0.25)
	newTween.play()
	
	await newTween.finished
	
	neededAmount = randf_range(10.0, maxAmount)
	
	indicator.visible = true
	indicator.position = Vector2(0, 6 - 12 * neededAmount/100)
	
	canPour = true

func finishPouring():
	if not pouring: return
	pouring = false
	canPour = false
	
	await get_tree().create_timer(0.75).timeout
	
	spillParticles.emitting = false
	indicator.visible = false
	
	successIndicator.texture = cross
	if abs(amount-neededAmount) < 5.0:
		ExtraVisuals.playSound(load("res://Assets/Music/success.mp3"), station.global_position)
		successIndicator.texture = checkmark
		gottenCups += 1
		cupCounter.text = str(gottenCups) + "/" + str(neededCups)
		
		if neededCups <= gottenCups:
			get_parent().compleatedTask()
	else:
		ExtraVisuals.playSound(load("res://Assets/Music/hurt_fail.mp3"), station.global_position)
	successIndicator.visible = true
	
	var newTween = create_tween()
	newTween.tween_property(cup, "global_position", Vector2(conveyor.global_position.x + conveyor.size.x - 32, cup.global_position.y), 0.25)
	newTween.play()
	
	await newTween.finished
	
	successIndicator.visible = false
	
	nextCup()

func pour():
	if(amount + pourSpeed) > 100:
		spillParticles.emitting = true
	else:
		spillParticles.emitting = false
	
	var newParticle = Sprite2D.new()
	newParticle.texture = cirlceSprite
	newParticle.modulate = Color.SADDLE_BROWN
	
	newParticle.global_position = particlePos.global_position + Vector2(randi_range(-6, 6), 0)
	add_child(newParticle)
	var newTween = create_tween()
	newTween.tween_property(newParticle, "global_position", Vector2(newParticle.global_position.x, cup.global_position.y), 0.5)
	newTween.play()
	newTween.connect("finished", deleteParticle.bind(newParticle))

func _input(_event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("Throw") and !pouring and canPour and visible:
		#pouring = true
		
		#while pouring:
			#pour()
			#await get_tree().create_timer(0.1).timeout
	
	#if event.is_action_released("Throw") and pouring:
		#finishPouring()

func _on_pour_button_button_down() -> void:
	if pouring or !canPour: return
	
	pouring = true
	while pouring:
		pour()
		await get_tree().create_timer(0.1).timeout

func _on_pour_button_button_up() -> void:
	finishPouring()

func deleteParticle(particle):
	particle.queue_free()
	
	amount = clamp(amount + pourSpeed, 0, 100)
	fill.scale = Vector2(1, -1 * clamp(amount/maxAmount, 0, 1))
