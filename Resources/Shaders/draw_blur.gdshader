shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

void fragment() {
  float value = textureLod(screen_texture, UV, 1.0).r;
  value = 2.0 * min(value + 0.5, 1.0) - 1.0;
  COLOR = vec4(vec3(value * value * value), 1.0);
}
