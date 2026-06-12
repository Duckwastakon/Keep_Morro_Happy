extends CharacterBody2D

@export var id = 0
var item = null

var player = null
var inRange = false

@onready var spriteRender = $itemSprite
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item = Global.Items[id]
	if(!item):
		queue_free()
	
	spriteRender.color = item.sprite
	
	look_at(velocity)

func _process(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 10)
	
	
	if(inRange and player != null and player.get_parent().pickedUpItem == null):
		look_at(velocity)
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
