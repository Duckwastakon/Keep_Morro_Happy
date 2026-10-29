shader_type canvas_item;

uniform float border: hint_range(0.0, 0.2, 0.01) = 0.1;

void fragment() {
	vec4 color = texture(TEXTURE, UV); 
	COLOR.a = color.a * (1.0 - round(distance(vec2(0.5, 0.5), UV) - border));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
