shader_type canvas_item;
render_mode blend_disabled;

uniform float contrast = 1.0;
uniform sampler2D color_ramp;

void fragment() {
    vec3 s = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	vec4 mask = texture(TEXTURE, UV);
	
	vec3 c = s;
	c.rgb = mix(vec3(0.0), c.rgb, 1.5);
    c.rgb = mix(vec3(0.5), c.rgb, 1.5);
    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, 0.0);
	vec4 ramp = texture(color_ramp, vec2(c.r, 0.0));
	
    COLOR.rgb = ramp.rgb * 3.0;
	
	COLOR.a = mask.a * ramp.a;
}