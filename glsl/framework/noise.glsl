#include "constants.glsl"
#include "helper.glsl"
#include "easing.glsl"

#ifndef NOISE
#define NOISE


const float NOISE_SCALE = 12.0;
const float LAYERED_SCALE = 0.25;
const float WHITE_NOISE_SCALE = 5461.0;


//////////////////////////////
// Random / Noises
//////////////////////////////

//https://www.shadertoy.com/view/4djSRW
float noise_white(float p)
{
    p *= WHITE_NOISE_SCALE;
    p = fract(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

float noise_white(vec2 p)
{
    p *= WHITE_NOISE_SCALE;
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float noise_white(vec3 p)
{
    p *= WHITE_NOISE_SCALE;
	p  = fract(p * .1031);
    p += dot(p, p.yzx + 33.33);
    return fract((p.x + p.y) * p.z);
}

vec2 noise_white_vec2(float p)
{
    p *= WHITE_NOISE_SCALE;
	vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx+p3.yz)*p3.zy);

}

vec2 noise_white_vec2(vec2 p)
{
    p *= WHITE_NOISE_SCALE;
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+33.33);
    return fract((p3.xx+p3.yz)*p3.zy);

}

vec2 noise_white_vec2(vec3 p)
{
    p *= WHITE_NOISE_SCALE;
	p = fract(p * vec3(.1031, .1030, .0973));
    p += dot(p, p.yzx+33.33);
    return fract((p.xx+p.yz)*p.zy);
}

vec3 noise_white_vec3(float p)
{
    p *= WHITE_NOISE_SCALE;
   vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
   p3 += dot(p3, p3.yzx+33.33);
   return fract((p3.xxy+p3.yzz)*p3.zyx); 
}

vec3 noise_white_vec3(vec2 p)
{
    p *= WHITE_NOISE_SCALE;
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz+33.33);
    return fract((p3.xxy+p3.yzz)*p3.zyx);
}

vec3 noise_white_vec3(vec3 p)
{
    p *= WHITE_NOISE_SCALE;
	p = fract(p * vec3(.1031, .1030, .0973));
    p += dot(p, p.yxz+33.33);
    return fract((p.xxy + p.yxx)*p.zyx);
}


float noise_value(float point, float seed, float smoothness)
{
    point *= NOISE_SCALE;

    float corner = floor(point);
    float interpolation = easing_power_inout(fract(point), smoothness);

    float A = noise_white(corner + 0.0 + seed);
    float B = noise_white(corner + 1.0 + seed);

    return mix(A, B, interpolation);
}

float noise_value(vec2 point, vec2 seed, float smoothness)
{
    point *= NOISE_SCALE;
    
    vec2 corner = floor(point);
    vec2 interpolation = easing_power_inout(fract(point), vec2(smoothness));
    
    float A = noise_white(corner + vec2(0.0, 0.0) + seed);
    float B = noise_white(corner + vec2(1.0, 0.0) + seed);
    float C = noise_white(corner + vec2(0.0, 1.0) + seed);
    float D = noise_white(corner + vec2(1.0, 1.0) + seed);

    return mix(
        mix(A, B, interpolation.x),
        mix(C, D, interpolation.x),
        interpolation.y
    );
}

float noise_value_layered(float point, float seed, float smoothness, int layers, float gain, float scale)
{
    point *= LAYERED_SCALE;

    float result = 0.0;
    float height_sum = 0.0;
    
    float frequency = 1.0;
    float amplitude = 1.0;

    for(int layer = 0; layer < layers; layer++)
    {
        result += noise_value(point * frequency, seed++, smoothness) * amplitude;
        height_sum += amplitude;
        
        frequency *= scale;
        amplitude *= gain;
    }

    return result / height_sum;
}

float noise_value_layered(vec2 point, vec2 seed, float smoothness, int layers, float gain, float scale)
{  
    point *= LAYERED_SCALE;

    float result = 0.0;
    float height_sum = 0.0;
    
    float frequency = 1.0;
    float amplitude = 1.0;

    for(int layer = 0; layer < layers; layer++)
    {
        result += noise_value(point * frequency, seed++, smoothness) * amplitude;
        height_sum += amplitude;
        
        frequency *= scale;
        amplitude *= gain;
    }

    return result / height_sum;
}


float noise_perlin(float point, float seed)
{
    point *= NOISE_SCALE;

    float corner = floor(point);
    float A = noise_white(corner + 0.0 + seed) * 2.0 - 1.0;
    float B = noise_white(corner + 1.0 + seed) * 2.0 - 1.0;

    point = fract(point);
    float interpolation = easing_smoother_step(point);

    return mix(
        dot(A, point - 0.0),
        dot(B, point - 1.0),
        interpolation
    ) * 0.5 + 0.5;
}

float noise_perlin(vec2 point, vec2 seed)
{
    point *= NOISE_SCALE;

    vec2 corner = floor(point);
    vec2 A = noise_white_vec2(corner + vec2(0.0, 0.0) + seed) * 2.0 - 1.0;
    vec2 B = noise_white_vec2(corner + vec2(1.0, 0.0) + seed) * 2.0 - 1.0;
    vec2 C = noise_white_vec2(corner + vec2(0.0, 1.0) + seed) * 2.0 - 1.0;
    vec2 D = noise_white_vec2(corner + vec2(1.0, 1.0) + seed) * 2.0 - 1.0;

    point = fract(point);
    vec2 interpolation = easing_smoother_step(point);

    return mix(
            mix(
                dot(A, point - vec2(0.0, 0.0)),
                dot(B, point - vec2(1.0, 0.0)),
                interpolation.x
            ),
            mix(
                dot(C, point - vec2(0.0, 1.0)),
                dot(D, point - vec2(1.0, 1.0)),
                interpolation.x
            ),
            interpolation.y
    ) * 0.5 + 0.5;
}


float noise_perlin_layered(float point, float seed, int layers, float gain, float scale)
{
    point *= LAYERED_SCALE;

    float result = 0.0;
    float height_sum = 0.0;
    
    float frequency = 1.0;
    float amplitude = 1.0;

    for(int layer = 0; layer < layers; layer++)
    {
        result += noise_perlin(point * frequency, seed++) * amplitude;
        height_sum += amplitude;
        
        frequency *= scale;
        amplitude *= gain;
    }

    return result / height_sum;
}

float noise_perlin_layered(vec2 point, vec2 seed, int layers, float gain, float scale)
{
    point *= LAYERED_SCALE;

    float result = 0.0;
    float height_sum = 0.0;
    
    float frequency = 1.0;
    float amplitude = 1.0;

    for(int layer = 0; layer < layers; layer++)
    {
        result += noise_perlin(point * frequency, seed++) * amplitude;
        height_sum += amplitude;
        
        frequency *= scale;
        amplitude *= gain;
    }

    return result / height_sum;
}


float noise_voronoi(vec2 point, out vec2 cell_id, vec2 seed)
{

    point *= NOISE_SCALE;

    vec2 tile_id = floor(point);
    vec2 tile_pos = fract(point);

    float min_dot = 10.0;
    for(float x = -1.0; x < 1.5; x++)
    {
        for(float y = -1.0; y < 1.5; y++)
        {
            vec2 offset = vec2(x, y);
            vec2 center = offset + noise_white_vec2(tile_id + seed + offset) - tile_pos;
            float center_dot = dot(center, center);
            
            if (min_dot > center_dot)
            {
                min_dot = center_dot;
                cell_id = tile_id + offset;
            }
        }
    }

    return sqrt(min_dot) * SQRT205;
}


//https://www.iquilezles.org/www/articles/voronoilines/voronoilines.htm
//https://www.ronja-tutorials.com/2018/09/29/voronoi-noise.html
float noise_voronoi_edge(vec2 point, out vec2 cell_id, vec2 seed)
{
    point *= NOISE_SCALE;

    vec2 tile_id = floor(point);
    vec2 tile_pos = fract(point);

    vec2 nearest_offset;
    vec2 nearest_center;

    float min_dot = 10.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 offset = vec2(i, j);
        vec2 random_position = noise_white_vec2(tile_id + offset + seed);
        vec2 center = offset + random_position - tile_pos;

        float current_dot = dot(center, center);
        if(min_dot > current_dot)
        {
            min_dot = current_dot;
            cell_id = tile_id + offset;

            nearest_center = center;
            nearest_offset = offset;
        }
    }

    min_dot = 10.0;
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 offset = nearest_offset + vec2(i, j);
        vec2 random_position = noise_white_vec2(tile_id + offset + seed);
        vec2 center = offset + random_position - tile_pos;

        vec2 edge = (nearest_center + center) * 0.5;
        float current_dot = dot(edge, normalize(center - nearest_center));

        min_dot = min(min_dot, current_dot);
    }

    return min_dot;
}

float noise_voronoi_manhattan(vec2 point, vec2 seed)
{
    point *= NOISE_SCALE;

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
            center = noise_white_vec2(tile_id + seed + neighbour);
            dist = min(dist, value_manhatten_length(center - tile_pos + neighbour));
        }
    }

    return dist * 0.5;
}

#endif
