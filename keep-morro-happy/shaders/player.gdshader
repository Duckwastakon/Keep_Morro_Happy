shader_type canvas_item;

uniform vec4 outlineColor = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool corners = false;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	if(base.a > 0.0) {
		COLOR = base;
	}
	else{
		vec2 imagePixelSize = TEXTURE_PIXEL_SIZE;
		bool validSide = 
		texture(TEXTURE, UV + vec2(-imagePixelSize.x, 0)).a > 0.0 ||
		texture(TEXTURE, UV + vec2(imagePixelSize.x, 0)).a > 0.0 ||
		texture(TEXTURE, UV + vec2(0, -imagePixelSize.y)).a > 0.0 ||
		texture(TEXTURE, UV + vec2(0, imagePixelSize.y)).a > 0.0;
		bool validCorner = 
		texture(TEXTURE, UV + vec2(-imagePixelSize.x, -imagePixelSize.y)).a > 0.0 ||
		texture(TEXTURE, UV + vec2(-imagePixelSize.x, imagePixelSize.y)).a > 0.0 ||
		texture(TEXTURE, UV + vec2(imagePixelSize.x, -imagePixelSize.y)).a > 0.0 ||
		texture(TEXTURE, UV + vec2(imagePixelSize.x, imagePixelSize.y)).a > 0.0;
		
		if (validSide || (validCorner && corners)){
			COLOR = outlineColor;
		}
	}
	
}
