shader_type spatial;
render_mode unshaded;

uniform sampler2D tex_albedo: source_color;
uniform vec3 tint: source_color  = vec3(1.0);

void fragment() {

	ALBEDO = texture(tex_albedo, FRAGCOORD.xy / VIEWPORT_SIZE).rgb * tint;

}
