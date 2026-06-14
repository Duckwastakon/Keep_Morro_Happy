@tool

extends RichTextEffect
class_name Wobbly

var bbcode = "wobbly"

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
	var speed = char_fx.env.get("freq", 5.0)
	var waveAmount = char_fx.env.get("wave", 0.0)
	var dim = char_fx.env.get("dim", 0.0)
	var amp = char_fx.env.get("amp", 1.0)
	
	var pos = Vector2(0,sin(char_fx.elapsed_time * speed + (char_fx.range.x * waveAmount) * amp))
	var alpha = 1 - abs(sin(char_fx.elapsed_time * speed/2)) * dim / 3
	
	char_fx.color.a = alpha
	char_fx.offset = pos
	return true
