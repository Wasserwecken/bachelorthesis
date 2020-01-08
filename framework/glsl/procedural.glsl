//////////////////////////////
// Constants
//////////////////////////////
float PI025 = 0.78539816339;
float PI05 = 1.57079632674;
float PI = 3.14159265359;
float PI2 = 6.28318530718;
float RADTODEG = 57.295779513;
float DEGTORAD = 0.01745329252;



//////////////////////////////
// Value manipulations
//////////////////////////////
float value_remap(float value, float in_lower, float in_upper, float out_lower, float out_upper)
{
    value -= in_lower;
    value *= out_upper - out_lower;
    value /= in_upper - in_lower;
    value += out_lower;

    return value;
}

float value_linear_step(float value, float edge, float edge_width)
{
    float f = (value - edge + (edge_width * .5)) / edge_width;
    return clamp(f, 0.0, 1.0);
}

vec2 value_linear_step(vec2 value, vec2 edge, vec2 edge_width)
{
    return vec2(
        value_linear_step(value.x, edge.x, edge_width.x),
        value_linear_step(value.y, edge.y, edge_width.y)
    );
}



//////////////////////////////
// Easing (http://gizma.com/easing/)
//////////////////////////////
float easing_power_in(float x, float power)
{
    return pow(x, power);
}

float easing_power_out(float x, float power)
{
    return 1.0 - pow(1.0 - x, power);
}

float easing_power_inout(float x, float power)
{
    x *= 2.0;

    float is_in = step(x, 1.0);
    float ease_in = easing_power_in(x, power);
    float ease_out = easing_power_out(x - 1.0, power);

    float ease = is_in * ease_in + (1.0 - is_in) * (ease_out + 1.0);

    return ease * .5;
}

float easing_circular_in(float x)
{
    x = min(x, 1.0);
    return 1.0 - sqrt( 1.0 - x * x);
}

float easing_circular_out(float x)
{
    x = max(x, 0.0);
    return sqrt(1.0 - --x * x);
}

float easing_circular_inout(float x)
{
    x *= 2.0;

    float is_in = step(x, 1.0);
    float ease_in = easing_circular_in(x);
    float ease_out = easing_circular_out(x - 1.0);

    float ease = is_in * ease_in + (1.0 - is_in) * (ease_out + 1.0);

    return ease * .5;
}



//////////////////////////////
// Noises
//////////////////////////////
float noise_white(vec2 seed)
{
    return fract(sin(dot(seed, vec2(12.9898, 78.233))) * 43758.5453);
}


float noise_perlin(vec2 seed, float scale)
{
    vec2 p = seed * scale;

    float p1 = noise_white(vec2(floor(p)));
    float p2 = noise_white(vec2(ceil(p.x), floor(p.y)));
    float p3 = noise_white(vec2(floor(p.x), ceil(p.y)));
    float p4 = noise_white(vec2(ceil(p)));

    p = fract(p);
    p.x = easing_circular_inout(p.x);
    p.y = easing_circular_inout(p.y);

    float nx = mix(p1, p2, p.x);
    float ny = mix(p3, p4, p.x);

    return mix(nx, ny, p.y);
}

float noise_simplex(vec2 seed)
{
    return 0.0;
}

float noise_voronoi(vec2 seed)
{
    return 0.0;
}



//////////////////////////////
// Shapes
//////////////////////////////
float shape_circle(vec2 uv, vec2 origin, float radius, float blur)
{
    float len = length(uv - origin);
    return 1.0 - value_linear_step(len, radius, blur);
}

float shape_rectangle(vec2 uv, vec2 origin, vec2 size, vec2 blur)
{
    size *= 0.5;
    uv = abs(uv - origin);
    
    vec2 isRectangle = value_linear_step(size, uv, blur);
    return min(isRectangle.x, isRectangle.y);
}

float shape_spiral(vec2 uv, vec2 origin, float start)
{
    uv -= origin;

    float spiral = (atan(uv.x, uv.y) + PI) / PI2;
    spiral = fract(spiral + 0.5 - start);

    return spiral;  
}

float shape_ngon(vec2 uv, vec2 origin, float radius, float edges, float bend, float blur)
{
    float dist = length(uv - origin);
    float spiral = shape_spiral(uv, origin, 0.0); 

    bend = (bend + 1.0) * 0.5 * PI2;
    spiral = fract(spiral * edges) * 2.0 - 1.0;
    dist *= cos(spiral * (bend / edges));

    return 1.0 - value_linear_step(dist, radius, blur);
}


//////////////////////////////
// UV
//////////////////////////////
vec2 uv_translate(vec2 uv, vec2 diff)
{
    return uv + diff;
}

vec2 uv_scale(vec2 uv, vec2 scale)
{
    return uv * scale;
}

vec2 uv_rotate(vec2 uv, vec2 origin, float angle)
{
    angle *= DEGTORAD;
    float s = sin(angle);
	float c = cos(angle);
	mat2 m = mat2(c, -s, s, c);

    uv -= origin;
    uv = m * uv;
    uv += origin;

	return uv;
}

vec2 uv_to_polar(vec2 uv, vec2 origin)
{
    float len = length(uv - origin);
    float angle = shape_spiral(uv, origin, 0.0);

    return vec2(angle, len);
}

vec2 uv_tilling(vec2 uv, vec2 tiles, out vec2 tile_id)
{
    uv *= tiles;
    
    tile_id = floor(uv);
    return fract(uv);
}

vec2 uv_tilling_offset(vec2 uv, out vec2 tile_id, float offset_step, float offset)
{
    uv += tile_id;

    uv.x += offset * floor(tile_id.y * (1.0 / offset_step));
    
    tile_id = floor(uv);
    return fract(uv);
}




void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.y;
    float blur = abs(sin(iTime * .5) * 0.1);
    
    vec2 id;
    //uv = uv_tilling(uv, vec2(30.0), id);
    //uv = uv_tilling_offset(uv, id, 1.0, 0.0);

    float result = noise_perlin(uv, 30.0);


    vec3 color = vec3(result);
	gl_FragColor = vec4(color, 1.0);
}