extends Area2D

@export var bookId = 5
var neededBooks = 10
var books = 0

signal taskCompleated

var itemPrefab = preload("res://CharacterScenes/item.tscn")
@onready var bookIndicator: Label = $indicator

func _ready() -> void:
	neededBooks = randi_range(5, 7)
	
	bookIndicator.text = str(books) + "/" + str(neededBooks)
	
	for n in neededBooks:
		var pos = get_parent().getPossiblePosition() #Vector2(randi_range(0, Global.difficulties[Global.difficulty].mapSize.x), randi_range(0, Global.difficulties[Global.difficulty].mapSize.y))
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
	bookIndicator.text = str(books) + "/" + str(neededBooks)
	if books >= neededBooks/2:
		$BookShelf.frame = 1
	if books >= neededBooks:
		$BookShelf.frame = 2
		$CollisionShape2D.queue_free()
		taskCompleated.emit()
