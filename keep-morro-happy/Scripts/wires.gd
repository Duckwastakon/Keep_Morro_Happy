extends Control

@export var wireAmount = 3
@export var wireSize = Vector2(16, 16)

@onready var wireContainer = $wiresContainer
var Con = []

var Comb1 = []
var Comb2 = []

var hoveringSlot
var startSlot

var currentWire

var station

func hoverWire(wire):
	hoveringSlot = wire

func exitWire(wire):
	if hoveringSlot == wire:
		hoveringSlot = null

func _process(_delta: float) -> void:
	if currentWire:
		currentWire.set_point_position(1, get_global_mouse_position() - startSlot.global_position)

func _ready() -> void:
	wireAmount = Global.difficulties[Global.difficulty].wireAmount
	wireSize = Vector2(wireContainer.size.x / (wireAmount + 6), wireContainer.size.x / (wireAmount + 6))
	var Wires1 = []
	var Wires2 = []
	
	var wireSpace = wireContainer.size.y
	var freeSpace = (wireSpace - wireAmount * wireSize.y) / (wireAmount + 1)
	
	for i in wireAmount:
		Con.append(false)
		
		var newWire1 = ColorRect.new()
		var newWire2 = ColorRect.new()
		
		newWire1.size = wireSize
		wireContainer.add_child(newWire1)
		newWire1.position = Vector2(0, freeSpace * (i+1) + i * wireSize.y)
		newWire2.size = wireSize
		wireContainer.add_child(newWire2)
		newWire2.position = Vector2(wireContainer.size.x - wireSize.x, freeSpace * (i+1) + i * wireSize.y)
		
		newWire1.connect("mouse_entered", hoverWire.bind(newWire1))
		newWire2.connect("mouse_entered", hoverWire.bind(newWire2))
		newWire1.connect("mouse_exited", exitWire.bind(newWire1))
		newWire2.connect("mouse_exited", exitWire.bind(newWire2))
		
		Wires1.append(newWire1)
		Wires2.append(newWire2)
	
	for i in wireAmount:
		var randNum = randi_range(0, Wires1.size() - 1)
		Comb1.append(Wires1[randNum])
		Wires1.pop_at(randNum)
		
		randNum = randi_range(0, Wires2.size() - 1)
		Comb2.append(Wires2[randNum])
		Wires2.pop_at(randNum)
	
	for i in wireAmount:
		var clr = Color8(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255))
		Comb1[i].color = clr
		Comb2[i].color = clr

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ThrowMouse") and visible and hoveringSlot != null:
		var newWire = Line2D.new()
		newWire.add_point(hoveringSlot.global_position - hoveringSlot.global_position + (hoveringSlot.size/2))
		newWire.add_point(get_global_mouse_position() - hoveringSlot.global_position)
		newWire.default_color = hoveringSlot.color
		currentWire = newWire
		newWire.width = wireSize.y / 1.5
		
		var num = Comb1.find(hoveringSlot)
		Con[num] = false
		
		for child in hoveringSlot.get_children():
			child.queue_free()
		
		hoveringSlot.add_child(newWire)
		
		startSlot = hoveringSlot
	
	if event.is_action_released("ThrowMouse") and visible and startSlot != null:
		if hoveringSlot != null:
			var newWire = Line2D.new()
			newWire.add_point(startSlot.global_position - startSlot.global_position + (startSlot.size/2))
			newWire.add_point(hoveringSlot.global_position- startSlot.global_position + (startSlot.size/2))
			newWire.default_color = startSlot.color
			newWire.width = wireSize.y / 1.5
			
			startSlot.add_child(newWire)
			
			currentWire.queue_free()
			currentWire = null
			
			var num = Comb1.find(startSlot)
			if num == -1:
				num = Comb2.find(startSlot)
			
			
			if num != -1:
				if Comb2[num] == hoveringSlot and Comb1[num] == startSlot or Comb1[num] == hoveringSlot and Comb2[num] == startSlot:
					Con[num] = true
					print("connected")
					for i in Con.size():
						if Con[i] == false:
							return
					
					ExtraVisuals.playSound(load("res://Assets/Music/success.mp3"), station.global_position)
					get_parent().compleatedTask()
			
			startSlot = null
		else:
			if currentWire is Line2D:
				currentWire.queue_free()
				currentWire = null
				startSlot = null
