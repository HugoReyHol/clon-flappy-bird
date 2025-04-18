shader_type canvas_item;


uniform sampler2D background_day;
uniform sampler2D background_night;
uniform float mix_amount = 0.0;


void fragment() {
	vec4 day = texture(background_day, UV);
	vec4 night = texture(background_night, UV);
	COLOR = mix(day, night, mix_amount);
}