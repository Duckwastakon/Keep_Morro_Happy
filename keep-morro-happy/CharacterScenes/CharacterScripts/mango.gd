extends CharacterBody2D

const speed = 200
const sprintSpeed = 200

var canMove = true
var wantsPets = false
var neededPets = 0

var infoText = null
var playerInRange = null
@export var player : CharacterBody2D = null

@onready var navigation = $NavigationAgent2D

@onready var movementTimer = $movementTimer
@onready var petTimer = $petDesireTimer

func _ready() -> void:
	infoText = ExtraVisuals.loadInfo(self, "Spam e to pet")

func _physics_process(delta: float) -> void:
	if wantsPets and player and !playerInRange:
		canMove = true
		var newTargetPosition = player.global_position
		navigation.target_position = newTargetPosition
		
		if randi_range(1, 100) < 30:
			ExtraVisuals.floatingText("PET MEEE!!!", global_position)
	
	if navigation.is_navigation_finished() or !canMove:
		return

	var currentPos: Vector2 = global_position
	var nextPathPos: Vector2 = navigation.get_next_path_position()

	velocity = currentPos.direction_to(nextPathPos) * speed
	
	move_and_slide()

func _on_movement_timer_timeout() -> void:
	var newTargetPosition = Vector2(randi_range(0, Global.mapSize.x), randi_range(0, Global.mapSize.y))
	navigation.target_position = newTargetPosition

func _on_navigation_agent_2d_navigation_finished() -> void:
	movementTimer.start()

func _on_interactions_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		playerInRange = true
		player = area.get_parent()
		
		if wantsPets:
			canMove = false
			player.canMove = false
			infoText.visible = true

func _on_interactions_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player":
		playerInRange = false
		infoText.visible = false

func _on_pet_desire_timer_timeout() -> void:
	if player == null: return
	
	wantsPets = true
	neededPets = randi_range(15, 50)
	
	if playerInRange:
		canMove = false
		player.canMove = false

func _input(event: InputEvent) -> void:
	if wantsPets and playerInRange and event.is_action_pressed("Throw"):
		print("Petted")
		neededPets -= 1
		ExtraVisuals.floatingText("Petted", global_position)
		
		if neededPets <= 0:
			wantsPets = false
			canMove = true
			player.canMove = true
			petTimer.start()
			
			infoText.visible = false
			
			var newTargetPosition = Vector2(randi_range(0, Global.mapSize.x), randi_range(0, Global.mapSize.y))
			navigation.target_position = newTargetPosition
