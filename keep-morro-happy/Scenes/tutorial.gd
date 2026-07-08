extends Control

var i = 0
func _on_close_button_down() -> void:
	visible = false

func openPage():
	for x in 9:
		get_child(x).visible = false
	
	get_child(i).visible = true

func _on_back_button_down() -> void:
	i -= 1
	i = clamp(i, 0, 9)
	openPage()

func _on_next_button_down() -> void:
	i += 1
	i = clamp(i, 0, 9)
	openPage()
