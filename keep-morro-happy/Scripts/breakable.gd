extends Node2D

var broken = false

var puddleSpill = preload("res://Scenes/puddle_spill.tscn")

func _ready() -> void:
	# Choose random texture from possible or material
	
	pass # Replace with function body.

func destroy():
	var newPuddle = puddleSpill.instantiate()
	newPuddle.global_position = global_position
	broken = true
	
	self.visible = false
	get_parent().get_parent().add_child(newPuddle)
	
	await newPuddle.child_exiting_tree
	
	self.visible = true
	broken = false
