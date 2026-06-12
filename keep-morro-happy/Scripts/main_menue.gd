extends Control

@onready var levelButtons = $levelButtons
func _ready() -> void:
	for btn in levelButtons.get_children():
		btn.connect("mouse_entered", selectButton.bind(btn, true))
		btn.connect("mouse_exited", selectButton.bind(btn, false))
		btn.connect("button_up", loadLevel.bind(btn.name))

func loadLevel(level):
	pass

func selectButton(btn, val):
	print("Yp")
	if val:
		btn.get_child(0).pop()
		btn.get_child(0).push_customfx(Wobbly, {"wave": 100})
		btn.get_child(0).push_bold()
	else:
		pass
