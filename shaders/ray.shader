shader_type canvas_item;
render_mode blend_add;

uniform float line_width = 0.05;
uniform vec4 color : hint_color;
uniform vec4 border_color : hint_color;

vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec2 mod289vec2(vec2 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
vec3 permute(vec3 x) { return mod289(vec3((x*34.0)+1.0)*x); }

float snoise(vec2 v) {

    // Precompute values for skewed triangular grid
    const vec4 C = vec4(0.211324865405187,
                        // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,
                        // 0.5*(sqrt(3.0)-1.0)
                        -0.577350269189626,
                        // -1.0 + 2.0 * C.x
                        0.024390243902439);
                        // 1.0 / 41.0

    // First corner (x0)
    vec2 i  = floor(v + dot(v, C.yy));
    vec2 x0 = v - i + dot(i, C.xx);

    // Other two corners (x1, x2)
    vec2 i1 = vec2(0.0);
    i1 = (x0.x > x0.y)? vec2(1.0, 0.0):vec2(0.0, 1.0);
    vec2 x1 = x0.xy + C.xx - i1;
    vec2 x2 = x0.xy + C.zz;

    // Do some permutations to avoid
    // truncation effects in permutation
    i = mod289vec2(i);
    vec3 p = permute(
            permute( i.y + vec3(0.0, i1.y, 1.0))
                + i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(
                        dot(x0,x0),
                        dot(x1,x1),
                        dot(x2,x2)
                        ), 0.0);

    m = m*m ;
    m = m*m ;

    // Gradients:
    //  41 pts uniformly over a line, mapped onto a diamond
    //  The ring size 17*17 = 289 is close to a multiple
    //      of 41 (41*7 = 287)

    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    // Approximation of: m *= inversesqrt(a0*a0 + h*h);
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0+h*h);

    // Compute final noise value at P
    vec3 g = vec3(0.0);
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * vec2(x1.x,x2.x) + h.yz * vec2(x1.y,x2.y);
    return 130.0 * dot(m, g);
}

float draw_ray(vec2 st, float variance, float weight) {
	float xpos = st.x + ((((weight ) - 0.25)) * variance);
	xpos = min(xpos, 1.0 - xpos);
	float width = line_width; //+ st.y*0.05;
	return smoothstep(0.5 - width -0.01, 0.5 - width + 0.01, xpos);
}

void fragment() {
	COLOR = color * 1.7;
	COLOR.a = 0.0;
	
	vec2 u_resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 st = FRAGCOORD.xy/u_resolution.xy; // <- para que tome pos globales

	float variance = min(st.y, 1.0 - st.y) * 0.5;
	
	float weight = snoise(st*vec2(15.0,15.0) + vec2(TIME*2.1, 0.0)); //+ vec2(TIME*2.1, 0.0)
	float pattern = sin(UV.y * 12.0 + TIME*15.0) * 0.2;
	//COLOR = vec4(vec3(weight), 1.0);
	COLOR.a = draw_ray(UV + vec2(pattern, 0.0), variance, weight);
	
	weight = snoise(st*vec2(10.0,20.0) + vec2(TIME*9.1, 1.0));
	COLOR.a += 0.2*draw_ray(UV, variance, weight);
	
	weight = snoise(st*vec2(5.0,5.0) + vec2(TIME*8.1, 1.0));
	COLOR.a += 0.2*draw_ray(UV, variance, weight);
	
	COLOR *= 2.3;
}