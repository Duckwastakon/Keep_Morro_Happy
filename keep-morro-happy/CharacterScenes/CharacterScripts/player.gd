extends CharacterBody2D

const speedStat = 30
var speed = 30
const deceleration = 15
const maxSpeed = 500

var canMove = true

var throwDirection = Vector2.ZERO

@onready var interactionInfo = $interactionInformation
@onready var loadingBar = $loadingBar
var itemPrefab = preload("res://CharacterScenes/item.tscn")
var pickedUpItem = null
var pickUpId = null
var interactTask = null

var inRangeMorro = null
var inRange = false
@onready var inventory = $inventory

func _ready() -> void:
	tasks.player = self

func _process(_delta: float) -> void:
	if !canMove: return
	#4 way movement
	var xDirection = Input.get_axis("Left", "Right")
	var yDirection = Input.get_axis("Up", "Down")
	
	var direction = Vector2(xDirection, yDirection).normalized()
	if xDirection > velocity.x/abs(velocity.x) || xDirection < velocity.x/abs(velocity.x):
		velocity.x -= velocity.x/abs(velocity.x) * deceleration
	if yDirection > velocity.y/abs(velocity.y) || yDirection < velocity.y/abs(velocity.y):
		velocity.y -= velocity.y/abs(velocity.y) * deceleration
	
	if direction != Vector2.ZERO:
		throwDirection = direction
	velocity += direction * speed;
	velocity.x = clampf(velocity.x, -maxSpeed, maxSpeed)
	velocity.y = clampf(velocity.y, -maxSpeed, maxSpeed)
	
	if (xDirection == 0):
		if abs(velocity.x) <= deceleration:
			velocity.x = 0
		else:
			velocity.x -= velocity.x/abs(velocity.x) * deceleration
	
	if (yDirection == 0):
		if abs(velocity.y) <= deceleration:
			velocity.y = 0
		else:
			velocity.y -= velocity.y/abs(velocity.y) * deceleration
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if !canMove: return
	#Item throwing
	if event.is_action_pressed("Throw") and inRangeMorro != null and inRange:
		canMove = false
		await loadingBar.fire(0.5)
		canMove = true
		
		inRangeMorro.pet()
	elif interactTask != null and event.is_action_pressed("Throw"):
		tasks.openTask(interactTask)
	elif pickedUpItem != null:
		var ThrowVelocity = Vector2.ZERO
		if event.is_action_pressed("Throw") and !Global.mouseThrow or event.is_action_pressed("ThrowMouse") and Global.mouseThrow:
			if !Global.mouseThrow:
				if velocity != Vector2.ZERO:
					ThrowVelocity = velocity.normalized() * Global.throwSpeed
				else:
					ThrowVelocity = throwDirection * Global.throwSpeed
			else:
				ThrowVelocity = global_position.direction_to(get_global_mouse_position()) * Global.throwSpeed
			var newItem = itemPrefab.instantiate()
			newItem.global_position = global_position
			newItem.id = pickedUpItem
			newItem.velocity = ThrowVelocity
			
			get_parent().add_child(newItem)
			pickedUpItem = null
			inventory.dropItem()
	elif pickUpId != null and event.is_action_pressed("Throw"):
		pickUpItem(pickUpId)

func _on_player_area_area_entered(area: Area2D) -> void:
	var itemId = area.get_parent().id
	if(itemId != null and pickedUpItem == null):
		area.get_parent().queue_free()
		pickUpItem(itemId)

func pickUpItem(itemId):
	print("picked up")
	pickedUpItem = itemId
	inventory.grabItem(pickedUpItem)

func removeItem():
	pickedUpItem = null
	inventory.dropItem()

func clean():
	canMove = false
	velocity = Vector2.ZERO
	await loadingBar.fire(Global.cleanTime)
	
	canMove = true

func stun():
	ExtraVisuals.floatingText("Ouch!", global_position)
	
	speed = speedStat - randi_range(20, 25)
	
	while speed < speedStat:
		speed += randf_range(0.5, 1)
		print(speed)
		
		await get_tree().create_timer(1).timeout
	
	speed = speedStat
