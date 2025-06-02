shader_type spatial;

uniform sampler2D tex_albedo: source_color;

void fragment() {

	ALBEDO = texture(tex_albedo, FRAGCOORD.xy / VIEWPORT_SIZE).rgb;

}
