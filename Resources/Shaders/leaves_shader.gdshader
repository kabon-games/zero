shader_type canvas_item;

uniform float value = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR = tex;
	if (tex.g > 150.0 / 250.0 && value >= 0.0) {
		COLOR.rgb = tex.rgb + vec3(value);
	}
}
