shader_type canvas_item;

uniform vec4 blinkColor = vec4(1, 1, 0, 1);
uniform float speed: hint_range(0.0, 10.0, 1.0) = 3.0;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	
	COLOR = mix(base, blinkColor, abs(sin(TIME * speed)));
	COLOR.a *= base.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
