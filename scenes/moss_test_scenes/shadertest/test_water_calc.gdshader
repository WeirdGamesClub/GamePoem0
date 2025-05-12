shader_type canvas_item;

uniform sampler2D buffer1; //prev
uniform sampler2D buffer2; //current

uniform sampler2D splash_source: hint_default_white; //source of new splashes

uniform float dampening;
uniform float velocity;

const float uvoffset = 1.0 / 512.0;

//note: apparently the higher the canvaslayer in scene tree = 
//the earlier the shader will go

float ripplesSim(sampler2D input, sampler2D current, sampler2D previous, vec2 uv) {
	
	float sample_dist = uvoffset / velocity;
	float prev_sample = texture(previous, uv).x;
	//float curr_sample = texture(current, uv).x;
	float left = texture(current, uv + vec2(sample_dist, 0)).x;
	float right = texture(current, uv + vec2(-sample_dist, 0)).x;
	float up = texture(current, uv + vec2(0, sample_dist)).x;
	float down = texture(current, uv + vec2(0, -sample_dist)).x;
	
	//vec3 newheight = (vec3(2) * (average * velocity + curr_sample)/(velocity + vec3(1)) - prev_sample);

	float combined = (right + left + up + down);
	float input_sample = 1.0 - texture(input, uv).x;
	float newheight = (combined / 2.0) - prev_sample;
	float next = (newheight + input_sample) * dampening;
	
	return float(next);
}

vec3 buffer_test(vec3 source, sampler2D current, vec2 uv) {
	//shifts current texture to left, adds source again
	
	vec3 right = texture(current, vec2(uv.x - uvoffset, uv.y)).xyz;
	
	return right + source;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	//vec3 source_sample = vec3(1) - texture(splash_source, UV).xyz;
	
	//COLOR = vec4(source_sample, 1);
	//COLOR = vec4(buffer_test(source_sample, buffer2, UV), 1);

	COLOR = vec4(vec3(ripplesSim(splash_source, buffer2, buffer1, UV)), 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
