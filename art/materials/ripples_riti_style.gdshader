shader_type spatial;

// set by script
uniform vec3 ripple_pos_arr[14];
uniform float ripple_time_arr[14];
uniform int active_ripples;
uniform float rip_radius;
uniform float rip_width;

uniform sampler2D tex_albedo: source_color;


// returns a float representing slope of ripple
// 0 = flat / facing up, 1 = maximum slope
// negative values face away from center
float get_ripple(float dist, float radius, float width) {

	float pow_scale = 0.7; // controls shape of curve
	float ceil_scale = 0.5; // controls max height of curve

	// check if "dist" is within "width" of "radius"
	float offset = dist - radius;
	if(abs(offset) < width) {

		// get distance from center or edges of ripple
		// 0..1..0..-1..0
		float dist_from_center = abs(offset) * 2.0 - width;
		float slope = 1.0 - abs(dist_from_center/width);

		// scale
		float slope_scaled = pow(slope, pow_scale);
		slope_scaled *= -sign(offset);
		slope_scaled *= ceil_scale;

		return slope_scaled;

	} else {
		return -1.0; //default value
	}
}

// get direction from ripple position to local vertex
// spits out a value -1 to 1
// do some fuck shit to account for us going around a cylinder
//    (rotation to transform from local space to tangent space)
vec2 get_direction_from_ripple(vec3 local_vertex, vec3 final_ripple_pos) {

	vec2 tangent_direction = vec2(0.0);

	// only set a new direction if there's a valid ripple position
	// otherwise this breaks?
	if(final_ripple_pos != vec3(0.0)) {

		// get signed angle between ripple pos & (0, 0, -1) (up)
		float angle = atan(final_ripple_pos.x * -1.0, final_ripple_pos.z * -1.0);

		// rotation matrix about y-axis
		mat3 rotation = mat3(vec3(cos(angle), 0.0, -sin(angle)),
						vec3(0.0, 1.0, 0.0),
						vec3(sin(angle), 0.0, cos(angle)));

		// rotate vertex position from local to tangent-space-relative-to-ripple
		vec3 tangent_vertex = local_vertex * rotation;

		// get direction from vertex to center of ripple in tangent space
		tangent_direction = normalize((vec3(0.0, final_ripple_pos.y, -1.0)- tangent_vertex).xy);

	}

	return tangent_direction;
}


void vertex() {
}

void fragment() {

	// local vertices
	vec3 local_vertex = (inverse(MODEL_MATRIX) * INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;

	float final_ripple_slope = 0.0;
	vec3 final_ripple_pos = vec3(0.0);
	float final_ripple_time = 1.0;

	// iterates through array of ripples
	// gets slope of ripple for this fragment
	for(int i = 0; i < active_ripples; i++) {
		// get this vertex's distance from ripple center
		// compare to expected radius of ripple (based on time)
		float vertex_distance = distance(ripple_pos_arr[i], local_vertex);
		float curr_rip_radius = rip_radius * ripple_time_arr[i];
		float curr_ripple_slope = get_ripple(vertex_distance, curr_rip_radius, rip_width);

		// only use the color from the most recent ripple
		if(curr_ripple_slope > -1.0 && ripple_time_arr[i] < final_ripple_time) {
			final_ripple_time = ripple_time_arr[i];
			final_ripple_pos = ripple_pos_arr[i];

			// fade out over time
			curr_ripple_slope *= 1.0 - ripple_time_arr[i];

			final_ripple_slope = curr_ripple_slope;
		}
	}

	// get direction from this fragment to the ripple center
	vec2 tangent_direction = get_direction_from_ripple(local_vertex, final_ripple_pos);

	// x is facing the wrong way and im too tired to figure out why
	tangent_direction = vec2(-tangent_direction.x, tangent_direction.y);

	// make normal

	// scale tangent direction by final_color
	// use inverse slope as z value
	vec2 scaled_direction = tangent_direction * final_ripple_slope;
	float direction_z = 1.0 - abs(final_ripple_slope);
	vec3 normal_vector = normalize(vec3(scaled_direction, direction_z));

	// scale from -1 to 1 --> 0 to 1
	vec3 normal_map = fma(normal_vector,vec3(0.5), vec3(0.5));

	NORMAL_MAP = normal_map;

	ALBEDO = texture(tex_albedo, FRAGCOORD.xy / VIEWPORT_SIZE).rgb;

}
