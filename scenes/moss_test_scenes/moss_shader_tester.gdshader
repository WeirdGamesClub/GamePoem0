shader_type spatial;

uniform sampler2D tex_albedo: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//ALBEDO = normalize(vec3(FRAGCOORD.x, FRAGCOORD.y, 0));
	ALBEDO = texture(tex_albedo, FRAGCOORD.xy / VIEWPORT_SIZE).rgb;
	//ALBEDO = texture(tex_albedo, vec2(UV.x, UV.y)).rgb;
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
