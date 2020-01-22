//////////////////////////////
// Constants
//////////////////////////////
float SQRT205 = 0.707106781186;
float SQRT2 = 1.41421356237;
float PI025 = 0.78539816339;
float PI05 = 1.57079632674;
float PI = 3.14159265359;
float PI2 = 6.28318530718;
float RADTODEG = 57.295779513;
float DEGTORAD = 0.01745329252;


//////////////////////////////
// Value manipulations
//////////////////////////////
float value_manhatten_length(vec2 vector)
{
    vector = abs(vector);
    return vector.x + vector.y;
}

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
float easing_smoother_step(float x)
{
    return x * x * x * (6.0 * x * x - 15.0 * x + 10.0);
}

vec2 easing_smoother_step(vec2 x)
{
    return x * x * x * (6.0 * x * x - 15.0 * x + 10.0);
}

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
// Random / Noises
//////////////////////////////
vec2 random_vector(vec2 p)
{
	p = vec2( dot(p,vec2(127.1,311.7)),
			  dot(p,vec2(269.5,183.3)) );
	return -1. + 2.*fract(sin(p+3.)*53758.5453123);
}

float random_value(float point)
{
    return fract(sin(point) * 43758.5453123);
}

float random_value(vec2 point)
{
    return fract(sin(dot(point, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise_value(vec2 point, float scale)
{
    point *= scale;
    vec2 corner = floor(point);
    vec2 interpol = easing_smoother_step(fract(point));
    
    float A = random_value(corner + vec2(0.0, 0.0));
    float B = random_value(corner + vec2(1.0, 0.0));
    float C = random_value(corner + vec2(0.0, 1.0));
    float D = random_value(corner + vec2(1.0, 1.0));

    return mix(
        mix(A, B, interpol.x),
        mix(C, D, interpol.x),
        interpol.y
    );
}

float noise_perlin(vec2 point, float scale)
{
    point *= scale;

    vec2 corner = floor(point);
    vec2 A = random_vector(corner + vec2(0.0, 0.0));
    vec2 B = random_vector(corner + vec2(1.0, 0.0));
    vec2 C = random_vector(corner + vec2(0.0, 1.0));
    vec2 D = random_vector(corner + vec2(1.0, 1.0));

    point = fract(point);
    vec2 interpol = easing_smoother_step(point);

    return mix(
            mix(
                dot(A, point - vec2(0.0, 0.0)),
                dot(B, point - vec2(1.0, 0.0)),
                interpol.x
            ),
            mix(
                dot(C, point - vec2(0.0, 1.0)),
                dot(D, point - vec2(1.0, 1.0)),
                interpol.x
            ),
            interpol.y
    ) * 0.5 + 0.5;
}

float noise_perlin_layered(vec2 uv, float scale, float diff, float layers)
{
    float noise = noise_perlin(uv, scale);
    float weight = 1.0;
    float max_value = 1.0;

    for(float l = 1.0; l < layers; l++)
    {
        scale *= diff;
        weight /= diff;
        max_value += weight;

        noise += noise_perlin(uv, scale) * weight;
    }

    return value_remap(noise, 0.0, max_value, 0.0, 1.0);
}

vec2 noise_perlin_vector(vec2 point, float scale)
{
    return vec2(
        noise_perlin(point, scale),
        noise_perlin(-point, scale)
    );
}

float noise_voronoi(vec2 point, float scale)
{
    point = point * scale;

    vec2 tile_id = floor(point);
    vec2 tile_pos = fract(point);

    vec2 neighbour;
    vec2 center;
    float dist = 10.0;

    for(float x = -1.0; x < 2.0; x++)
    {
        for(float y = -1.0; y < 2.0; y++)
        {
            neighbour = vec2(x, y);
            center = abs(random_vector(tile_id + neighbour));
            dist = min(dist, length(center - tile_pos + neighbour));
        }
    }

    return dist * SQRT205;
}

vec2 noise_voronoi_vector(vec2 point, float scale)
{
    return vec2(
        noise_voronoi(point, scale),
        noise_voronoi(-point, scale)
    );
}

float noise_voronoi_manhattan(vec2 point, float scale)
{
    point *= scale;

    vec2 tile_id = floor(point);
    vec2 tile_pos = fract(point);

    vec2 neighbour;
    vec2 center;
    float dist = 10.0;

    for(float x = -1.0; x < 2.0; x++)
    {
        for(float y = -1.0; y < 2.0; y++)
        {
            neighbour = vec2(x, y);
            center = abs(random_vector(tile_id + neighbour));
            dist = min(dist, value_manhatten_length(center - tile_pos + neighbour));
        }
    }

    return dist * 0.5;
}

vec2 noise_voronoi_manhattan_vector(vec2 point, float scale)
{
    return vec2(
        noise_voronoi_manhattan(point, scale),
        noise_voronoi_manhattan(-point, scale)
    );
}

float noise_simplex(vec2 point, float scale)
{
    point *= scale;

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

vec2 uv_tilling(vec2 uv, vec2 tiles, out vec2 tile_id, out float tile_aspect_ratio)
{
    uv *= tiles;
    
    tile_id = floor(uv);
    tile_aspect_ratio = tiles.y / tiles.x;
    return fract(uv);
}

vec2 uv_tilling_offset(vec2 uv, out vec2 tile_id, float offset_step, float offset)
{
    uv += tile_id;

    uv.x += offset * floor(tile_id.y * (1.0 / offset_step));
    
    tile_id = floor(uv);
    return fract(uv);
}

vec2 uv_warp_directional(vec2 uv, vec2 distortion, float strength)
{
    distortion = (distortion * 2.0 - 1.0) * strength;
    return uv - distortion;
}

vec2 uv_warp_rotational(vec2 uv, float offset, float distortion, float strength)
{
    distortion = ((distortion * 360.0) - 180.0) * strength;
    return uv_rotate(uv, uv + vec2(offset), distortion);
}













float wood(vec2 uv)
{
    vec2 noise_uv = uv * vec2(10.0, 1.5);
    float ring_noise = noise_perlin_layered(noise_uv, 1.0, 1.5, 4.0);
    ring_noise = pow(ring_noise, 2.0);
    vec2 ring_uv = uv_warp_rotational(uv, 1.0, ring_noise, .06) * 20.0;

    vec2 primary_uv = ring_uv;
    float primary_id = floor(primary_uv.x);
    float primary_gradient = random_value(primary_id);
    float primary_lines = fract(primary_uv.x);
    float primary = primary_gradient * primary_lines;
    primary = value_remap(primary, 0.0, 1.0, 0.5, 1.0);

    float secondary_line_count = 2.0 + ceil(random_value(primary_id) * 3.0);
    vec2 secondary_uv = primary_uv * secondary_line_count;
    float secondary_id = floor(secondary_uv.x);
    float secondary_gradient = random_value(secondary_id);
    float secondary_lines = fract(secondary_uv.x);
    float secondary = secondary_gradient * secondary_lines;
    secondary = value_remap(secondary, 0.0, 1.0, 0.75, 1.0);
    float rings = primary * secondary;


    vec2 dot_uv = uv * vec2(10.0, 2.0);
    float dots = noise_perlin_layered(dot_uv, 75.0, 2.0, 2.0);
    dots = easing_smoother_step(dots);
    dots = value_remap(dots, 0.0, 1.0, 0.8, 1.0);

    vec2 variance_uv = uv * vec2(10.0, 1.0) * 4.0;
    float variance = noise_perlin_layered(variance_uv, 2.0, 4.0, 3.0);
    variance = easing_smoother_step(variance);
    variance = value_remap(variance, 0.0, 1.0, 0.75, 1.0);

    return rings * dots * variance;
}











void main() {
    vec2 uv = gl_FragCoord.xy / iResolution.y;
    vec2 mouse = -iMouse.xy / iResolution.y;

    uv += mouse;

    float iTime2 = sin(iTime) * .5 + .5;


    vec2 parquet_uv = uv;
    vec2 bar_id;
    float bar_aspect_ratio;
    parquet_uv = uv_tilling(uv, vec2(2.0, 20.0), bar_id, bar_aspect_ratio);
    float parquet_offset = random_value(bar_id.y * 6.0);
    parquet_uv = uv_tilling_offset(parquet_uv, bar_id, 1.0, parquet_offset);

    vec2 wood_uv = uv_rotate(uv, vec2(0.0), 90.0);
    wood_uv += random_vector(bar_id);
    wood_uv *= 3.0;

    float wood = wood(wood_uv);
    float bar = shape_rectangle(parquet_uv,
            vec2(0.5),
            vec2(0.995, 0.95),
            vec2(0.01, 0.1)
        );



    vec3 color = vec3(wood * bar);
	gl_FragColor = vec4(color, 1.0);
}