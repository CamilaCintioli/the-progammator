shader_type canvas_item;
render_mode blend_add;

uniform float line_width = 0.05;
uniform vec4 color : hint_color;
uniform vec4 border_color : hint_color;
uniform sampler2D power_texture;
uniform vec2 voro = vec2(5.0, 5.0);
uniform float firing_angle = 0.0;

uniform float aspect = 1.0;
uniform float shield_reveal_percent : hint_range(0.0, 1.0) = 0.3;
uniform float shield_rotation_speed : hint_range(0.0, 10.0) = 0.3;
uniform float distortion = 1.0;
uniform vec4 shield_color : hint_color = vec4(0.4,1.0,0.4,1);

const float PI = 3.14159265;

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

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

// https://thebookofshaders.com/edit.php#12/2d-voronoi.frag
vec3 voronoi2( in vec2 uv, float columns, float rows) {
	vec2 n = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 f = fract(vec2(uv.x * columns, uv.y * rows));

    // first pass: regular voronoi
    vec2 mg, mr;
    float md = 1.0;
	vec2 min_point;
    for (int j= -1; j <= 1; j++) {
        for (int i= -1; i <= 1; i++) {
            vec2 g = vec2(float(i),float(j));
            vec2 o = random( n + g );

            vec2 r = g + o - f;
            float d = dot(r,r);

            if( d<md ) {
                md = d;
                mr = r;
                mg = g;
				min_point = o;
            }
        }
    }

    // second pass: distance to borders
    md = 8.0;
    for (int j= -2; j <= 2; j++) {
        for (int i= -2; i <= 2; i++) {
            vec2 g = mg + vec2(float(i),float(j));
            vec2 o = random( n + g );

            vec2 r = g + o - f;

            if ( dot(mr-r,mr-r)>0.00001 ) {
                md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            }
        }
    }
    return vec3(min_point, md);
}

float circle(in vec2 _st, in float _radius, float border){
    vec2 dist = _st-vec2(0.5);
	return 1.-smoothstep(_radius-(_radius*border),
                         _radius+(_radius*border),
                         dot(dist,dist)*4.0);
}

// https://godotshaders.com/shader/2d-radial-distortion-fisheye-barrel/
vec2 distort(vec2 p)
{
	float d = length(p);
	float z = sqrt(distortion + d * d * -distortion);
	float r = atan(d, z) / 3.1415926535;
	float phi = atan(p.y, p.x);
	return vec2(r * cos(phi) * (1.0 / aspect) + 0.5, r * sin(phi) + 0.5);
}

void fragment() {
	float timeFactor = TIME * shield_rotation_speed;
	vec2 firingPoint = vec2(cos(firing_angle), sin(firing_angle));
	vec2 centeredUv = UV * 2.0 - 1.0;
	float firingCircle = circle(UV + firingPoint * vec2(-0.5, -0.5) * 0.80 , 0.01, 3.0);
	float firingDistance = clamp(1.0 + shield_reveal_percent - distance(centeredUv, firingPoint), 0.0, 2.0);
	vec2 st = distort(centeredUv);
	vec3 cell = voronoi2(st + firingPoint * timeFactor, voro.x, voro.y);
	
	float cellBorder = clamp(1.0 - smoothstep(0.05, 0.06, cell.z), 0.0, 1.0);
	float innerCircle = circle(UV, 0.70 - 0.02 * firingDistance, 0.2);
	float outherCircle = circle(UV, 0.76, 0.2);
	float outline = outherCircle - innerCircle;
	float mask = cellBorder * innerCircle + outline + firingCircle;
	
	vec3 shield = mask * shield_color.rgb;
	
    COLOR = vec4(vec3(shield), 1.0 * (1.0 + mask * 1.4 + outline));
	COLOR *= firingDistance * 2.5;
}



