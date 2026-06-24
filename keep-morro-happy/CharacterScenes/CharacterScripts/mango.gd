extends CharacterBody2D

var speed = 200
const sprintSpeed = 350
const walkSpeed = 200

var canMove = true
var wantsPets = false
var neededPets = 0

var infoText = null
var playerInRange = null
@export var player : CharacterBody2D = null

@onready var navigation = $NavigationAgent2D
@onready var animator = $AnimationPlayer

@onready var movementTimer = $movementTimer
@onready var petTimer = $petDesireTimer

var heartSprite = preload("res://Assets/Art/heart.png")

func _ready() -> void:
	petTimer.wait_time = Global.petDesireTimer + randi_range(-(Global.petDesireTimer/10), Global.petDesireTimer/10)
	petTimer.start()
	
	infoText = ExtraVisuals.loadInfo(self, "Spam e to pet")

func _physics_process(delta: float) -> void:
	if wantsPets and player and !playerInRange:
		canMove = true
		var newTargetPosition = player.global_position
		navigation.target_position = newTargetPosition
		
		if randi_range(1, 100) < 5:
			ExtraVisuals.floatingText("PET MEEE!!!", global_position)
	
	if navigation.is_navigation_finished() or !canMove:
		animator.play("rest")
		return
	
	animator.play("run")
	var currentPos: Vector2 = global_position
	var nextPathPos: Vector2 = navigation.get_next_path_position()

	velocity = currentPos.direction_to(nextPathPos) * speed
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
	
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
	
	await get_tree().create_timer(10).timeout
	if wantsPets:
		speed = sprintSpeed

func _input(event: InputEvent) -> void:
	if wantsPets and playerInRange and event.is_action_pressed("Throw"):
		print("Petted")
		neededPets -= 1
		ExtraVisuals.floatingSprite(heartSprite, global_position)
		
		if neededPets <= 0:
			speed = walkSpeed
			wantsPets = false
			canMove = true
			player.canMove = true
			
			petTimer.wait_time = Global.petDesireTimer + randi_range(-(Global.petDesireTimer/10), Global.petDesireTimer/10)
			petTimer.start()
			
			infoText.visible = false
			
			var newTargetPosition = Vector2(randi_range(0, Global.mapSize.x), randi_range(0, Global.mapSize.y))
			navigation.target_position = newTargetPosition
