#include "constants.glsl"
#include "helper.glsl"
#include "easing.glsl"

#ifndef NOISE
#define NOISE


//////////////////////////////
// Random / Noises
//////////////////////////////

//https://www.shadertoy.com/view/4djSRW
float noise_white(float p)
{
    p *= 5461.0;
    p = fract(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

float noise_white(vec2 p)
{
    p *= 5461.0;
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float noise_white(vec3 p)
{
    p *= 5461.0;
	p  = fract(p * .1031);
    p += dot(p, p.yzx + 33.33);
    return fract((p.x + p.y) * p.z);
}

vec2 noise_white_vec2(float p)
{
    p *= 5461.0;
	vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx+p3.yz)*p3.zy);

}

vec2 noise_white_vec2(vec2 p)
{
    p *= 5461.0;
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+33.33);
    return fract((p3.xx+p3.yz)*p3.zy);

}

vec2 noise_white_vec2(vec3 p3)
{
    p3 *= 5461.0;
	p3 = fract(p3 * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+33.33);
    return fract((p3.xx+p3.yz)*p3.zy);
}

vec3 noise_white_vec3(float p)
{
    p *= 5461.0;
   vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
   p3 += dot(p3, p3.yzx+33.33);
   return fract((p3.xxy+p3.yzz)*p3.zyx); 
}

vec3 noise_white_vec3(vec2 p)
{
    p *= 5461.0;
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz+33.33);
    return fract((p3.xxy+p3.yzz)*p3.zyx);
}

vec3 noise_white_vec3(vec3 p3)
{
    p3 *= 5461.0;
	p3 = fract(p3 * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz+33.33);
    return fract((p3.xxy + p3.yxx)*p3.zyx);

}

float noise_value(vec2 point, vec2 seed, float scale)
{
    point *= scale;
    
    vec2 corner = floor(point);
    vec2 interpol = easing_smoother_step(fract(point));
    
    float A = noise_white(corner + vec2(0.0, 0.0) + seed);
    float B = noise_white(corner + vec2(1.0, 0.0) + seed);
    float C = noise_white(corner + vec2(0.0, 1.0) + seed);
    float D = noise_white(corner + vec2(1.0, 1.0) + seed);

    return mix(
        mix(A, B, interpol.x),
        mix(C, D, interpol.x),
        interpol.y
    );
}

float noise_perlin_vec1(float point, float seed, float scale)
{
    point *= scale;

    float corner = floor(point);
    float A = noise_white(corner + 0.0 + seed) * 2.0 - 1.0;
    float B = noise_white(corner + 1.0 + seed) * 2.0 - 1.0;

    point = fract(point);
    float interpol = easing_smoother_step(point);

    return mix(
        dot(A, point - 0.0),
        dot(B, point - 1.0),
        interpol
    ) * 0.5 + 0.5;
}

float noise_perlin_vec1_layered(float point, float seed, float scale, float layers, float diff_scale, float diff_weight)
{
    float noise = noise_perlin_vec1(point, seed, scale);
    float weight = 1.0;
    float max_value = 1.0;

    for(float l = 1.0; l < layers; l++)
    {
        scale *= diff_scale;
        weight /= diff_weight;
        max_value += weight;

        noise += noise_perlin_vec1(point, ++seed, scale) * weight;
    }

    return value_remap(noise, 0.0, max_value, 0.0, 1.0);
}

float noise_perlin(vec2 point, vec2 seed, float scale)
{
    point *= scale;

    vec2 corner = floor(point);
    vec2 A = noise_white_vec2(corner + vec2(0.0, 0.0) + seed) * 2.0 - 1.0;
    vec2 B = noise_white_vec2(corner + vec2(1.0, 0.0) + seed) * 2.0 - 1.0;
    vec2 C = noise_white_vec2(corner + vec2(0.0, 1.0) + seed) * 2.0 - 1.0;
    vec2 D = noise_white_vec2(corner + vec2(1.0, 1.0) + seed) * 2.0 - 1.0;

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

float noise_perlin_layered(vec2 uv, vec2 seed, float scale, float layers, float diff_scale, float diff_weight)
{
    float noise = noise_perlin(uv, seed, scale);
    float weight = 1.0;
    float max_value = 1.0;

    for(float l = 1.0; l < layers; l++)
    {
        scale *= diff_scale;
        weight /= diff_weight;
        max_value += weight;

        noise += noise_perlin(uv, ++seed, scale) * weight;
    }

    return value_remap(noise, 0.0, max_value, 0.0, 1.0);
}

float noise_voronoi(vec2 point, vec2 seed, float scale)
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
            center = abs(noise_white_vec2(tile_id + seed + neighbour));
            dist = min(dist, length(center - tile_pos + neighbour));
        }
    }

    return dist * SQRT205;
}

float noise_voronoi_manhattan(vec2 point, vec2 seed, float scale)
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
            center = abs(noise_white_vec2(tile_id + seed + neighbour));
            dist = min(dist, value_manhatten_length(center - tile_pos + neighbour));
        }
    }

    return dist * 0.5;
}

float noise_simplex(vec2 point, vec2 seed, float scale)
{
    point *= scale;

    return 0.0;
}

#endif
