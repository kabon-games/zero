shader_type canvas_item;
render_mode blend_mix;

void fragment() {
  float l = texture(TEXTURE, UV).r;
  float a = max(1.0 - l, 0.0);
  COLOR = vec4(0, 0, 0, a);
}