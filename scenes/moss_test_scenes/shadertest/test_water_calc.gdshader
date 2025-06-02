shader_type canvas_item;

uniform sampler2D buffer1; //prev
uniform sampler2D buffer2; //current

uniform vec2 splash_source_pt;
uniform float splash_size;

uniform float dampening;
uniform float velocity;

const float texsize = 512.0;
const float uvoffset = 1.0 / texsize;

//note: apparently the higher the canvaslayer in scene tree =
//the earlier the shader will go

// Generate splash source data at input point.
// returns 0 if point is within [offset] of [source_pt]
float splash_from_pt(vec2 source_pt, vec2 offset, vec2 uv,) {
	vec2 offset1 = step(uv, (source_pt + offset));
	vec2 offset2 = step(source_pt - offset, uv);
	vec2 combined = offset1 * offset2;
	float final = combined.x * combined.y;
	return final;
}

// simulate ripples.
// uses "2D water" algorithm from hugo elias.
// i kinda understand it but not really
// not sure it works right
float ripplesSim(float input, sampler2D current, sampler2D previous, float normal_scale, vec2 uv) {

	float sample_dist = uvoffset / velocity;
	float prev_sample = texture(previous, uv).x;
	float curr_sample = texture(current, uv).x;
	float left = texture(current, uv + vec2(sample_dist, 0)).x;
	float right = texture(current, uv + vec2(-sample_dist, 0)).x;
	float up = texture(current, uv + vec2(0, sample_dist)).x;
	float down = texture(current, uv + vec2(0, -sample_dist)).x;

	float combined = (right + left + up + down);
	float newheight = (combined / 2.0) - prev_sample;
	float next = (newheight + input) * dampening;

	return next;
}

//vec3 make_buffer(vec2 offsetUVs) {
	//return vec3((sin(distance(offsetUVs, vec2(.5)) * 100.0) + 1.0)/ 2.0);
//}
//
//vec3 calc_normal(float offset_amount, float height_range, vec2 uv) {
	//vec3 original = make_buffer(uv + vec2(0)).xyz;
	//float right = make_buffer(uv + vec2(offset_amount, 0.0)).x * height_range;
	//float left = make_buffer(uv + vec2(-1.0 * offset_amount, 0.0)).x * height_range;
	//float down = make_buffer(uv + vec2(0.0, offset_amount)).x * height_range;
	//float up = make_buffer(uv + vec2(0.0, -1.0 * offset_amount)).x * height_range;
//
	//vec3 calc_normal = normalize(vec3(left - right, 2.0 * offset_amount, up - down));
//
	//return calc_normal;
//}

void vertex() {
	// Called for every vertex the material is visible on.

}

void fragment() {
	// Called for every pixel the material is visible on.

	//vec3 source_sample = vec3(1) - texture(splash_source, UV).xyz;

	//COLOR = vec4(0.2, 0.4, 0.7, 1);

	//COLOR = vec4(source_sample, 1);
	//COLOR = vec4(buffer_test(source_sample, buffer2, UV), 1);
	//COLOR = vec4(UV.x, UV.y, 1, 1);
	//COLOR = vec4((splash_from_pt(vec2(0.4, 0.25), vec2(splash_size / texsize), UV)), 1, 1);
	float splashpt = splash_from_pt(splash_source_pt, vec2(splash_size/texsize), UV);
	float ripple = ripplesSim(splashpt, buffer2, buffer1, 1, UV);
	COLOR = vec4(vec3(ripple), 1);
	//COLOR = vec4(ripple.rgb, 1.0);
	//NORMAL_MAP = ripple.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}



// test sampling from buffers
//vec3 buffer_test(vec3 source, sampler2D current, vec2 uv) {
	////shifts current texture to left, adds source again
	//
	//vec3 right = texture(current, vec2(uv.x - uvoffset, uv.y)).xyz;
	//
	//return right + source;
//}
