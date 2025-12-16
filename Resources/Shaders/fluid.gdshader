shader_type canvas_item;

uniform float quantity = 0;

void fragment() {
	if (UV.y <  1.0 - quantity) {
		COLOR.a = 0.0;
	}
}

