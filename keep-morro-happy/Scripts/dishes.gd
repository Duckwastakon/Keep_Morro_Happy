extends Control

var station

var neededDishes = randi_range(2, 4)
var cleanedDishes = 0
@onready var dish = $dish
@onready var successIndicator = $successIndiator
@onready var dishCounter = $dishCounter

var dirtySpots = 0

var dirtParticle = preload("res://Assets/Art/brownTile.png")

func _ready() -> void:
	dishCounter.text = "0/" + str(neededDishes)
	nextDish()

func nextDish():
	for i in randi_range(3, 5):
		var newDirt = TextureButton.new()
		newDirt.texture_normal = dirtParticle
		newDirt.stretch_mode = TextureButton.STRETCH_SCALE
		newDirt.size = Vector2(32, 32)
		newDirt.position = Vector2(randi_range(32, dish.size.x - 32), randi_range(32, dish.size.y - 32))
		
		dish.add_child(newDirt)
		
		newDirt.connect("button_down", cleanSpot.bind(newDirt))
		dirtySpots += 1
	
	var newTween = create_tween()
	newTween.tween_property(dish, "modulate", Color8(255,255,255,255), 1)
	
	newTween.play()

func finishDish():
	successIndicator.visible = true
	cleanedDishes += 1
	
	dishCounter.text = str(cleanedDishes) + "/" + str(neededDishes)
	
	if cleanedDishes >= neededDishes:
		get_parent().compleatedTask()
	
	var newTween = create_tween()
	newTween.tween_property(dish, "modulate", Color(1,1,1,0), 1)
	
	newTween.play()
	
	await newTween.finished
	
	successIndicator.visible = false
	nextDish()

func cleanSpot(spot: TextureButton):
	spot.modulate = Color(1,1,1,spot.modulate.a - randf_range(0.15, 0.25))
	
	if spot.modulate.a <= 0.35:
		spot.queue_free()
		spotCleaned()

func spotCleaned():
	dirtySpots -= 1
	
	if dirtySpots <= 0:
		finishDish()
