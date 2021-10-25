shader_type canvas_item;

uniform float r_delay : hint_range(-1, 1, 0.1) = 0;
uniform float b_delay : hint_range(-1, 1, 0.1) = 0;
uniform float g_delay : hint_range(-1, 1, 0.1) = 0;
uniform sampler2D albedo : hint_albedo;
uniform sampler2D albedo_b : hint_black_albedo;
uniform sampler2D normal : hint_normal;
uniform sampler2D aniso : hint_aniso;
uniform sampler2D white : hint_white;
uniform sampler2D black : hint_black;

void vertex()
{
	//VERTEX = vec2(VERTEX.y, VERTEX.x) * UV.y;
}

void fragment()
{
//	highp vec4 col = vec4(cos(TIME + r_delay), sin(TIME + g_delay), sin(TIME + b_delay), 1.0);
//	COLOR = col;
}