extends Node2D

var broken = false

var puddleSpill = preload("res://Scenes/puddle_spill.tscn")
signal getBroken

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
