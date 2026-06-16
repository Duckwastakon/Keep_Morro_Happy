extends Area2D

@export var bookId = 5
var neededBooks = 10
var books = 0

var itemPrefab = preload("res://CharacterScenes/item.tscn")

func _ready() -> void:
	$Label.text = str(books) + "/" + str(neededBooks)
	neededBooks = randi_range(10, 15)
	
	for n in neededBooks:
		var pos = Vector2(global_position.x + randi_range(-100, 100), global_position.y + randi_range(-100, 100))
		var newItem = itemPrefab.instantiate()
		newItem.id = bookId
		newItem.global_position = pos
		get_parent().add_child.call_deferred(newItem)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		var player = area.get_parent()
		if player.pickedUpItem == bookId:
			player.removeItem()
			add_Book()
	else:
		if area.get_parent() is CharacterBody2D:
			var id = area.get_parent().id
			if id == bookId:
				area.get_parent().queue_free()
				add_Book()

func add_Book():
	books += 1
	$Label.text = str(books) + "/" + str(neededBooks)
	if books >= neededBooks:
		$CollisionShape2D.disabled = true
