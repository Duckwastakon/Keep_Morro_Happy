shader_type canvas_item;

uniform vec4 blinkColor = vec4(1);
uniform vec2 direction = vec2(1.0, 1.0);
uniform float speed = 0.5;
uniform float border: hint_range(0.0, 0.2, 0.01) = 0.1;

void fragment() {
	vec2 offset = TIME * speed * direction;
	
	vec2 uv = UV;
	uv *= 8.0;
	uv = mod(uv + offset, 1.0); 
	
	vec4 base = texture(TEXTURE, uv);
	
	COLOR = mix(base, blinkColor, abs(sin(TIME)));
	COLOR.a *= base.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
