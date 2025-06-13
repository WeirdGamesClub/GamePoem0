shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

uniform float scale = 0.25;
uniform sampler2D drawing_texture : source_color;

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
	vec4 texture_sample = texture(drawing_texture, UV);
	ALBEDO = texture_sample.rgb;
	ALPHA = texture_sample.a;
	ALPHA_SCISSOR_THRESHOLD = 0.5;

}
