shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

uniform float scale = 0.25;
uniform vec4 primary_color: source_color;
uniform vec4 secondary_color: source_color;
uniform sampler2D drawing_texture : source_color;
uniform float alpha_multiplier = 1.0;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			MAIN_CAM_INV_VIEW_MATRIX[0],
			MAIN_CAM_INV_VIEW_MATRIX[1],
			MAIN_CAM_INV_VIEW_MATRIX[2],
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	VERTEX *= scale;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
	vec4 texture_sample = texture(drawing_texture, UV);

	if(texture_sample.r > 0.0) {
		color = primary_color;
	} else if (texture_sample.g > 0.0) {
		color = secondary_color;
	}
	
	ALBEDO = color.rgb;
	ALPHA = color.a * alpha_multiplier;

}
