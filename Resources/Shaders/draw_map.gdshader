shader_type canvas_item;
render_mode unshaded;

void fragment() {
	vec4 tex_uv = texture(TEXTURE, UV);
	float is_block = step(0.001, tex_uv.a);
	COLOR = vec4(0,0,0, is_block);
}