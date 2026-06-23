extends CharacterBody2D


const speed = 200
const sprintSpeed = 200

var Happiness = 100

var canMove = true
var wantsPets = false

@export var foodId = 1
@export var WaterId = 2

@export var breakables : Node2D = null
@export var player: CharacterBody2D = null
var catch = false

var infoText = null

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
@onready var animationPlayer = $Animations
@onready var sprite = $Morro

@onready var navigation = $NavigationAgent2D

var poopPrefab = preload("res://CharacterScenes/poop.tscn")
var puddlePrefab = preload("res://Scenes/puddle_spill.tscn")

func _ready() -> void:
	infoText = ExtraVisuals.loadInfo(self, "Press e to pet")

func changeHappiness(amount):
	Happiness -= amount
	Happiness = clamp(Happiness, 0, 100)
	
	GameUi.updateHappiness(Happiness)

func _process(_delta: float) -> void:
	if catch and canMove:
		navigation.target_position = player.global_position
		
		print(global_position.distance_to(player.global_position))
		
		if global_position.distance_to(player.global_position) < 60:
			print("caught")
			catch = false
			player.stun()
			
			needTimer.start()
	
	if navigation.is_navigation_finished() or !canMove:
		animationPlayer.play("Sit")
		return
	
	animationPlayer.play("Move")
	var currentPos: Vector2 = global_position
	var nextPathPos: Vector2 = navigation.get_next_path_position()

	velocity = currentPos.direction_to(nextPathPos) * speed
	
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	move_and_slide()

func _on_need_timer_timeout() -> void:
	var action = randi_range(0, needs.size() - 1)
	call(needs[action])

func _on_movement_timer_timeout() -> void:
	var newTargetPosition = Vector2(randi_range(0, Global.mapSize.x), randi_range(0, Global.mapSize.y))
	navigation.target_position = newTargetPosition

func _on_navigation_agent_2d_target_reached() -> void:
	movementTimer.start()

func desirePets():
	print("pets pls")
	GameUi.addWarning("pets")
	petCount = randi_range(5, 10)
	
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
		ExtraVisuals.floatingText("Stop petting me!", global_position)
		return true
	
	if petCount <= 0 and !canMove and wantsPets == true:
		canMove = true
		wantsPets = false
		print("Happy")
		GameUi.removeWarning("pets")
		changeHappiness(-20)
		
		needTimer.start()

func destroy():
	if breakables != null:
		var possibilities = []
		
		for breakable in breakables.get_children():
			if !breakable.broken:
				possibilities.append(breakable)
		
		
		if possibilities.size() > 0:
			var randomBreakable = possibilities[randi_range(0, possibilities.size() - 1)]
			
			var newTargetPosition = randomBreakable.global_position
			navigation.target_position = newTargetPosition
			
			movementTimer.stop()
			
			await navigation.target_reached
			
			randomBreakable.destroy()
			needTimer.start()
			
			return
	
	needTimer.start()

func annoy():
	if player != null:
		print("catching")
		catch = true

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
		infoText.visible = true
	fulfilneed(area)

func _on_interactions_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player":
		area.get_parent().inRange = false
		infoText.visible = false
