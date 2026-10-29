extends CanvasLayer

@onready var buildEquip = $Panel/buildButton
@onready var buttonContainer = $Panel

func _ready() -> void:
	var i = 0
	for building in Global.buildings:
		var newButton: Button = buildEquip.duplicate()
		newButton.visible = true
		newButton.global_position = Vector2(16 * (i+1) + 64*i, newButton.global_position.y)
		buttonContainer.add_child(newButton)
		newButton.connect("button_down", click.bind(i))
		i+=1

func click(id):
	get_parent().equipItem(id)
