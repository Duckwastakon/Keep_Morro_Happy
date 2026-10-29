extends CharacterBody2D

@export var id = 0
var item = null

var player = null
var inRange = false

@onready var spriteRender = $itemSprite

func _ready() -> void:
	if id == 5:
		spriteRender.self_modulate = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1)
	item = Global.Items[id]
	if(!item):
		queue_free()
	
	spriteRender.texture = load(item.sprite)
	spriteRender.scale = Vector2(item.scale, item.scale)
	
	if velocity != Vector2.ZERO:
		rotation = 0
		spriteRender.look_at(velocity)
	else:
		rotation = randi_range(0, 360)

func _process(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 10)
	
	
	if(inRange and player != null and player.get_parent().pickedUpItem == null):
		rotation = 0
		spriteRender.look_at(player.global_position)
		velocity = Global.itemPullSpeed * global_position.direction_to(player.global_position)
	
	move_and_slide()

func _on_attraction_delay_timeout() -> void:
	$AttractionArea/AttractionShape.disabled = false
	$PickUp/CollisionShape2D.disabled = false

func _on_attraction_area_area_entered(area: Area2D) -> void:
	player = area
	inRange = true

func _on_attraction_area_area_exited(_area: Area2D) -> void:
	inRange = false
