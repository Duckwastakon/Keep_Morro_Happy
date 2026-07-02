shader_type canvas_item;

uniform vec4 blinkColor = vec4(0.2, 0, 0, 1);
uniform vec4 blinkColor2 = vec4(0,0,0,1);

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	
	COLOR = mix(blinkColor2, blinkColor, abs(sin(TIME)));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
