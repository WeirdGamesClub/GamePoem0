shader_type spatial;

uniform sampler2D screen_tex: source_color;
uniform sampler2D surface_tex: source_color;
uniform sampler2D test_texture: source_color;
uniform float surface_opacity = 0.4;
const float offset_amount = (1.0 / 512.0);
const float height_range = 0.05;

vec3 make_buffer(vec2 offsetUVs) {
	return vec3((sin(distance(offsetUVs, vec2(.5)) * 100.0) + 1.0)/ 2.0);
}

void vertex() {	
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	//vec3 screen_tex_sampled = texture(screen_tex, FRAGCOORD.xy / VIEWPORT_SIZE).rgb;
	//vec3 surface_tex_sampled = texture(surface_tex, UV.xy).rgb;
	//vec3 tex_combined = screen_tex_sampled * (vec3(1) - (surface_tex_sampled * surface_opacity));
	//ALBEDO = tex_combined;
	
	vec3 original = make_buffer( UV + vec2(0)).xyz;
	float right = make_buffer(UV + vec2(offset_amount, 0.0)).x * height_range;
	float left = make_buffer(UV + vec2(-1.0 * offset_amount, 0.0)).x * height_range;
	float down = make_buffer(UV + vec2(0.0, offset_amount)).x * height_range;
	float up = make_buffer(UV + vec2(0.0, -1.0 * offset_amount)).x * height_range;
	
	vec3 calc_normal = normalize(vec3(left - right, 2.0 * offset_amount, up - down));
	
	ALBEDO = vec3(.4);
	NORMAL_MAP = calc_normal;
	ROUGHNESS = 0.8;

}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
