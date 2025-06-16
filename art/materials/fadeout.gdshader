shader_type spatial;
render_mode unshaded;

uniform sampler2D albedo_texture: source_color;
uniform float alpha_multiplier;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texturesample = texture(albedo_texture, UV);

	ALBEDO = texturesample.xyz;
	ALPHA = texturesample.a * alpha_multiplier;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
