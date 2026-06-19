shader_type canvas_item;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 base = texture(TEXTURE, UV);
	
	COLOR = base;
	float sumdist = distance(vec2(0.5, 0.5), UV);
	
	COLOR.a = 0.5 - sumdist / 1.2;
}
