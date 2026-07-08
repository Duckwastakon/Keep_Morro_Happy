extends Node2D

var broken = false

var puddleSpill = preload("res://Scenes/puddle_spill.tscn")
signal getBroken

func _ready():
	$BreakableVase.frame = randi_range(0, ($BreakableVase.hframes / 2) - 1) * 2

func destroy():
	var newPuddle = puddleSpill.instantiate()
	newPuddle.global_position = global_position
	newPuddle.visible = false
	broken = true
	getBroken.emit(3, newPuddle)
	
	$BreakableVase.frame += 1
	get_parent().get_parent().add_child(newPuddle)
	
	await newPuddle.child_exiting_tree
	
	$BreakableVase.frame -= 1
	broken = false
