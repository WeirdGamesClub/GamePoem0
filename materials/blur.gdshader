shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest_mipmap;
uniform float lod: hint_range(0.0, 5) = 2.0;

void fragment(){
    COLOR = textureLod(screen_texture, SCREEN_UV, lod);
}
