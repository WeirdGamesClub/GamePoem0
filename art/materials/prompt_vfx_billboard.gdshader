shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

uniform float scale = 0.25;
uniform float rotation_speed = 1.0;
uniform bool negative = false;
uniform sampler2D drawing_texture : source_color;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			MAIN_CAM_INV_VIEW_MATRIX[0],
			MAIN_CAM_INV_VIEW_MATRIX[1],
			MAIN_CAM_INV_VIEW_MATRIX[2],
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	
	float time = TIME * rotation_speed;
	if(negative) {
		time = -time;
	}
	float sine = sin(time);
	float cosine = cos(time);
	
	MODELVIEW_MATRIX[0][0] *= sine;
	MODELVIEW_MATRIX[0][1] += cosine;
	MODELVIEW_MATRIX[1][0] += cosine;
	MODELVIEW_MATRIX[1][1] *= -sine;
	
	VERTEX *= scale;

}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_sample = texture(drawing_texture, UV);
	ALBEDO = texture_sample.rgb;
	ALPHA = texture_sample.a / 2.0;
}
