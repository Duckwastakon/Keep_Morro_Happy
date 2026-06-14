extends CanvasLayer

var warnings = {
	"pets": "Morro wants to be pet"
}

@onready var happinessBar = $morroHappiness/barBackground/progress
@onready var warningContainer = $warnings/warningContainer

func setActive():
	for i in get_children():
		i.visible = true

func updateHappiness(happiness):
	var size: float = clampf(float(happiness) / 100, 0, 100)
	var newTween = create_tween()
	newTween.tween_property(happinessBar, "scale", Vector2(size, 1), 0.1)
	newTween.play()

func addWarning(warning):
	var newWarning = Label.new()
	newWarning.text = warnings[warning]
	newWarning.name = warning
	
	warningContainer.add_child(newWarning)

func removeWarning(warning):
	var foundWarning = warningContainer.get_node(warning)
	
	if foundWarning:
		foundWarning.queue_free()
