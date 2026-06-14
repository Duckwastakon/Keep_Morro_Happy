extends CharacterBody2D


const speed = 100
const sprintSpeed = 200

var canMove = true
var wantsPets = false

var playerInRange = null

@onready var navigation = $NavigationAgent2D

@onready var movementTimer = $movementTimer
@onready var petTimer = $petDesireTimer

func _physics_process(delta: float) -> void:
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
	pass # Replace with function body.

func _on_interactions_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
