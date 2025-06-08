shader_type canvas_item;

uniform vec4 primary_color;
uniform vec4 secondary_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
	vec4 texture_sample = texture(TEXTURE, UV);
	

	if(texture_sample.r > 0.0) {
		color = primary_color;
	} else if (texture_sample.g > 0.0) {
		color = secondary_color;
	}
	
	COLOR = color;
}
