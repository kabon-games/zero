shader_type canvas_item;

uniform bool active = false;
uniform bool hide = false;
uniform vec3 color = vec3(1);
uniform float size = 0.1;
uniform vec4 modulate = vec4(0);

void fragment() {
	if (hide) {
		COLOR = vec4(0);
	} else {
		vec4 tex = texture(TEXTURE, UV);
		if (tex.a < 0.01) {
			tex.rgb = vec3(0);
		}
		vec4 background = modulate;
		background *= vec4(tex.a);
		COLOR = tex + background;
	}
	
	if (active) {
			vec2 position = vec2((UV.x - REGION_RECT.x) / REGION_RECT[2], (UV.y - REGION_RECT.y) / REGION_RECT[3]);
			if (position.x <= size || position.x >=  1.0 - size || position.y <= size || position.y >= 1.0 - size) {
				float c = cos(TIME * 4.0);
				float s = sin(TIME * 4.0);
				vec2 pos = vec2(position.x * 2.0 - 1.0, position.y * 2.0 - 1.0);
				if (pos.x - c < 0.40 && pos.x - c > -0.4 && pos.y - s < 0.40 && pos.y - s > -0.4
				|| (pos.x + c < 0.40 && pos.x + c > -0.4 && pos.y + s < 0.40 && pos.y + s > -0.4)) {
					COLOR.rgb = color;
					COLOR.a = 1.0;
				}
			}
		}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
