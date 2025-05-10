shader_type spatial;

uniform sampler2D screen_tex: source_color;
uniform sampler2D surface_tex: source_color;
uniform float surface_opacity = 0.4;

void vertex() {	
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec3 screen_tex_sampled = texture(screen_tex, FRAGCOORD.xy / VIEWPORT_SIZE).rgb;
	vec3 surface_tex_sampled = texture(surface_tex, UV.xy).rgb;
	vec3 tex_combined = screen_tex_sampled * (vec3(1) - (surface_tex_sampled * surface_opacity));
	ALBEDO = tex_combined;
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
