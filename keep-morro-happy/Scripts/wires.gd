extends Control

var Con = [false, false, false, false]
var c = 0

var Comb1 = []
var Comb2 = []

var hoveringWire = null
var connectingWire = null
var startingWire = null

var endingWire = null

var station

@onready var Wires1 = [$WireSprites/Wire1, $WireSprites/Wire2, $WireSprites/Wire3
,$WireSprites/Wire4]
@onready var Wires2 = [$WireSprites/Wire5, $WireSprites/Wire6, $WireSprites/Wire7
, $WireSprites/Wire8]

func _process(_delta: float) -> void:
	if connectingWire:
		connectingWire.set_point_position(1, get_global_mouse_position() - startingWire.global_position)

func _ready() -> void:
	for i in 4:
		var randNum = randi_range(0, Wires1.size() - 1)
		Comb1.append(Wires1[randNum])
		Wires1.pop_at(randNum)
		
		randNum = randi_range(0, Wires2.size() - 1)
		Comb2.append(Wires2[randNum])
		Wires2.pop_at(randNum)
	
	for i in 4:
		var clr = Color8(randi_range(0, 255), randi_range(0, 255), randi_range(0, 255))
		Comb1[i].color = clr
		Comb2[i].color = clr

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ThrowMouse") and visible and hoveringWire != null:
		var newWire = Line2D.new()
		newWire.add_point(hoveringWire.global_position - hoveringWire.global_position + (hoveringWire.size/2))
		newWire.add_point(get_global_mouse_position() - hoveringWire.global_position)
		newWire.default_color = hoveringWire.color
		connectingWire = newWire
		newWire.width = 20
		
		var num = Comb1.find(hoveringWire)
		Con[num] = false
		
		for child in hoveringWire.get_children():
			child.queue_free()
		
		hoveringWire.add_child(newWire)
		
		startingWire = hoveringWire
	
	if event.is_action_released("ThrowMouse") and visible and startingWire != null:
		if endingWire != null:
			var newWire = Line2D.new()
			newWire.add_point(startingWire.global_position - startingWire.global_position + (startingWire.size/2))
			newWire.add_point(endingWire.global_position- startingWire.global_position + (startingWire.size/2))
			newWire.default_color = startingWire.color
			newWire.width = 20
			
			startingWire.add_child(newWire)
			
			connectingWire.queue_free()
			connectingWire = null
			
			var num = Comb1.find(startingWire)
			
			startingWire = null
			
			if num != -1:
				if Comb2[num] == endingWire:
					Con[num] = true
					print("connected")
					for i in Con.size():
						if Con[i] == false:
							return
					get_parent().compleatedTask()
		else:
			if connectingWire is Line2D:
				connectingWire.queue_free()
				connectingWire = null
				startingWire = null

func _on_wire_1_mouse_entered() -> void:
	hoveringWire = $WireSprites/Wire1
func _on_wire_2_mouse_entered() -> void:
	hoveringWire = $WireSprites/Wire2
func _on_wire_3_mouse_entered() -> void:
	hoveringWire = $WireSprites/Wire3
func _on_wire_4_mouse_entered() -> void:
	hoveringWire = $WireSprites/Wire4
func _on_wire_5_mouse_entered() -> void:
	endingWire = $WireSprites/Wire5
func _on_wire_6_mouse_entered() -> void:
	endingWire = $WireSprites/Wire6
func _on_wire_7_mouse_entered() -> void:
	endingWire = $WireSprites/Wire7
func _on_wire_8_mouse_entered() -> void:
	endingWire = $WireSprites/Wire8
func _on_wire_1_mouse_exited() -> void:
	hoveringWire = null
func _on_wire_2_mouse_exited() -> void:
	hoveringWire = null
func _on_wire_3_mouse_exited() -> void:
	hoveringWire = null
func _on_wire_4_mouse_exited() -> void:
	hoveringWire = null
func _on_wire_5_mouse_exited() -> void:
	endingWire = null
func _on_wire_6_mouse_exited() -> void:
	endingWire = null
func _on_wire_7_mouse_exited() -> void:
	endingWire = null
func _on_wire_8_mouse_exited() -> void:
	endingWire = null
