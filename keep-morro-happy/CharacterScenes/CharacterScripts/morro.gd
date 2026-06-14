extends CharacterBody2D


const speed = 100
const sprintSpeed = 200

var Happiness = 100

var canMove = true
var wantsPets = false

@export var foodId = 1
@export var WaterId = 2

var petCount = 0

const needs = {
	0: "poop",
	1: "desirePets",
	2: "destroy",
	3: "annoy",
}

var hunger = 0
var thirst = 0

@onready var needTimer = $needTimer
@onready var movementTimer = $movementTimer

@onready var navigation = $NavigationAgent2D

var poopPrefab = preload("res://CharacterScenes/poop.tscn")
var puddlePrefab = preload("res://Scenes/puddle_spill.tscn")

func changeHappiness(amount):
	Happiness -= amount
	Happiness = clamp(Happiness, 0, 100)
	
	GameUi.updateHappiness(Happiness)

func _process(_delta: float) -> void:
	if navigation.is_navigation_finished() or !canMove:
		return

	var currentPos: Vector2 = global_position
	var nextPathPos: Vector2 = navigation.get_next_path_position()

	velocity = currentPos.direction_to(nextPathPos) * speed
	
	move_and_slide()

func _on_need_timer_timeout() -> void:
	var action = randi_range(0, 1) #needs.size() - 1)
	call(needs[action])

func _on_movement_timer_timeout() -> void:
	var newTargetPosition = Vector2(randi_range(0, Global.mapSize.x), randi_range(0, Global.mapSize.y))
	navigation.target_position = newTargetPosition

func _on_navigation_agent_2d_target_reached() -> void:
	movementTimer.start()

func desirePets():
	print("pets pls")
	GameUi.addWarning("pets")
	petCount += randi_range(5, 10)
	
	canMove = false
	wantsPets = true
	
	while petCount > 0:
		changeHappiness(randi_range(1, 2))
		await get_tree().create_timer(1).timeout
		print("-happiness")

func pet():
	print("petting")
	
	petCount -= 1
	if petCount < -3:
		changeHappiness(randi_range(8,12))
		return true
	
	if petCount <= 0 and !canMove and wantsPets == true:
		canMove = true
		wantsPets = false
		print("Happy")
		GameUi.removeWarning("pets")
		changeHappiness(-20)
		
		needTimer.start()

func poop():
	var newPoop = poopPrefab.instantiate()
	newPoop.global_position = global_position
	get_parent().add_child(newPoop)
	
	needTimer.start()

func basicNeeds():
	while self:
		hunger += randi_range(2, 5)
		thirst += randi_range(1, 2)
		
		if hunger >= 65 or thirst >= 65:
			changeHappiness(randi_range(0, 2))
		
		await get_tree().create_timer(randf_range(1.5, 2.5)).timeout

func fulfilneed(area):
	if area.get_parent() is not CharacterBody2D: return
	
	if area.get_parent().name == "player":
		var id = area.get_parent().pickedUpItem
		if id == foodId:
			area.get_parent().removeItem()
			hunger -= randi_range(30, 70)
		if id == WaterId:
			area.get_parent().removeItem()
			thirst -= randi_range(30, 70)
	else:
		var id = area.get_parent().id
		if id == foodId:
			area.get_parent().removeItem()
			hunger -= randi_range(30, 70)
		if id == WaterId:
			area.get_parent().removeItem()
			thirst -= randi_range(30, 70)


func _on_interactions_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		area.get_parent().inRangeMorro = self
		area.get_parent().inRange = true
	fulfilneed(area)


func _on_interactions_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player":
		area.get_parent().inRange = false
