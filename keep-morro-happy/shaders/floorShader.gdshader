shader_type canvas_item;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 base = texture(TEXTURE, UV);
	
	COLOR = base;
	float sumdist = distance(vec2(0.5, 0.5), UV);
	
	COLOR.a = 0.5 - sumdist / 1.2;
}
