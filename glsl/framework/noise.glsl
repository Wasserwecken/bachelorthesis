#include "constants.glsl"
#include "random.glsl"
#include "helper.glsl"
#include "easing.glsl"

#ifndef NOISE
#define NOISE


const float NOISE_SCALE = 12.0;
const float LAYERED_SCALE = 1.0;




//------------------------------------------------------
//------------------------------------------------------
//      TOOLS
//------------------------------------------------------
//------------------------------------------------------
float noise_vallies(float noise)
{
    return abs(noise * 2.0 -1.0);
}

vec2 noise_vallies(vec2 noise)
{
    return abs(noise * 2.0 -1.0);
}

vec3 noise_vallies(vec3 noise)
{
    return abs(noise * 2.0 -1.0);
}

float noise_creases(float noise)
{
    return 1.0 - noise_vallies(noise);
}

vec2 noise_creases(vec2 noise)
{
    return 1.0 - noise_vallies(noise);
}

vec3 noise_creases(vec3 noise)
{
    return 1.0 - noise_vallies(noise);
}



//------------------------------------------------------
//------------------------------------------------------
//      VALUE
//------------------------------------------------------
//------------------------------------------------------
float noise_value(float point, float seed, float smoothness)
{
    point *= NOISE_SCALE;

    float corner = floor(point);
    float interpolation = easing_power_inout(fract(point), smoothness);

    float A = random(corner + 0.0 + seed);
    float B = random(corner + 1.0 + seed);

    return mix(A, B, interpolation);
}

float noise_value(vec2 point, vec2 seed, float smoothness)
{
    point += random_vec2(seed++) * 2.0 - 1.0;
    point *= NOISE_SCALE;
    
    vec2 corner = floor(point);
    vec2 interpolation = easing_power_inout(fract(point), vec2(smoothness));
    
    float A = random(corner + vec2(0.0, 0.0) + seed);
    float B = random(corner + vec2(1.0, 0.0) + seed);
    float C = random(corner + vec2(0.0, 1.0) + seed);
    float D = random(corner + vec2(1.0, 1.0) + seed);

    return mix(
        mix(A, B, interpolation.x),
        mix(C, D, interpolation.x),
        interpolation.y
    );
}

float noise_value(vec3 point, vec3 seed, float smoothness)
{
    point *= NOISE_SCALE;
    
    vec3 corner = floor(point);
    vec3 interpolation = easing_power_inout(fract(point), vec3(smoothness));
    
    float A = random(corner + vec3(0.0, 0.0, 0.0) + seed);
    float B = random(corner + vec3(1.0, 0.0, 0.0) + seed);
    float C = random(corner + vec3(0.0, 1.0, 0.0) + seed);
    float D = random(corner + vec3(1.0, 1.0, 0.0) + seed);
    float E = random(corner + vec3(0.0, 0.0, 1.0) + seed);
    float F = random(corner + vec3(1.0, 0.0, 1.0) + seed);
    float G = random(corner + vec3(0.0, 1.0, 1.0) + seed);
    float H = random(corner + vec3(1.0, 1.0, 1.0) + seed);

    return mix(
            mix(
                mix(A, B, interpolation.x),
                mix(C, D, interpolation.x),
                interpolation.y
            ),
            mix(
                mix(E, F, interpolation.x),
                mix(G, H, interpolation.x),
                interpolation.y
            ),
            interpolation.z
        );
}

//------------------------------------------------------
//------------------------------------------------------
//      PERLIN NOISE
//------------------------------------------------------
//------------------------------------------------------
float noise_perlin(float point, float seed)
{
    point *= NOISE_SCALE;

    float corner = floor(point);
    float A = random(corner + 0.0 + seed) * 2.0 - 1.0;
    float B = random(corner + 1.0 + seed) * 2.0 - 1.0;

    point = fract(point);
    float interpolation = easing_smooth(point, 2);

    float noise = mix(
        dot(A, point - 0.0),
        dot(B, point - 1.0),
        interpolation
    );
    
    return noise * 0.5 + 0.5;
}

float noise_perlin(vec2 point, vec2 seed)
{
    point *= NOISE_SCALE;

    vec2 corner = floor(point);
    vec2 A = random_vec2(corner + vec2(0.0, 0.0) + seed) * 2.0 - 1.0;
    vec2 B = random_vec2(corner + vec2(1.0, 0.0) + seed) * 2.0 - 1.0;
    vec2 C = random_vec2(corner + vec2(0.0, 1.0) + seed) * 2.0 - 1.0;
    vec2 D = random_vec2(corner + vec2(1.0, 1.0) + seed) * 2.0 - 1.0;

    point = fract(point);
    vec2 interpolation = easing_smooth(point, ivec2(2));

    float noise = mix(
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
    );

    return noise * 0.5 + 0.5;
}

float noise_perlin(vec3 point, vec3 seed)
{
    point *= NOISE_SCALE;

    vec3 corner = floor(point);
    vec3 A = random_vec3(corner + vec3(0.0, 0.0, 0.0) + seed) * 2.0 - 1.0;
    vec3 B = random_vec3(corner + vec3(1.0, 0.0, 0.0) + seed) * 2.0 - 1.0;
    vec3 C = random_vec3(corner + vec3(0.0, 1.0, 0.0) + seed) * 2.0 - 1.0;
    vec3 D = random_vec3(corner + vec3(1.0, 1.0, 0.0) + seed) * 2.0 - 1.0;
    vec3 E = random_vec3(corner + vec3(0.0, 0.0, 1.0) + seed) * 2.0 - 1.0;
    vec3 F = random_vec3(corner + vec3(1.0, 0.0, 1.0) + seed) * 2.0 - 1.0;
    vec3 G = random_vec3(corner + vec3(0.0, 1.0, 1.0) + seed) * 2.0 - 1.0;
    vec3 H = random_vec3(corner + vec3(1.0, 1.0, 1.0) + seed) * 2.0 - 1.0;

    point = fract(point);
    vec3 interpolation = easing_smooth(point, ivec3(2));

    float noise = mix(
        mix(
            mix(
                dot(A, point - vec3(0.0, 0.0, 0.0)),
                dot(B, point - vec3(1.0, 0.0, 0.0)),
                interpolation.x
            ),
            mix(
                dot(C, point - vec3(0.0, 1.0, 0.0)),
                dot(D, point - vec3(1.0, 1.0, 0.0)),
                interpolation.x
            ),
            interpolation.y),
        mix(
            mix(
                dot(E, point - vec3(0.0, 0.0, 1.0)),
                dot(F, point - vec3(1.0, 0.0, 1.0)),
                interpolation.x
            ),
            mix(
                dot(G, point - vec3(0.0, 1.0, 1.0)),
                dot(H, point - vec3(1.0, 1.0, 1.0)),
                interpolation.x
            ),
            interpolation.y),
        interpolation.z
    );

    return noise * 0.5 + 0.5;
}

//------------------------------------------------------
//------------------------------------------------------
//      VORONOI DISTANCE
//------------------------------------------------------
//------------------------------------------------------
float noise_voronoi(float point, out float cell_id, float seed)
{
    point *= NOISE_SCALE;

    float tile_id = floor(point);
    float tile_pos = fract(point);

    float min_diff = 10.0;
    for(float x = -1.0; x < 1.5; x++)
    {
        float diff = x + random(tile_id + seed + x) - tile_pos;
        diff = abs(diff);
        
        if (min_diff > diff)
        {
            min_diff = diff;
            cell_id = tile_id + x;
        }
    }

    return min_diff;
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
            vec2 diff = offset + random_vec2(tile_id + seed + offset) - tile_pos;
            float diff_dot = dot(diff, diff);
            
            if (min_dot > diff_dot)
            {
                min_dot = diff_dot;
                cell_id = tile_id + offset;
            }
        }
    }

    return sqrt(min_dot) * SQRT205;
}

float noise_voronoi(vec3 point, out vec3 cell_id, vec3 seed)
{

    point *= NOISE_SCALE;

    vec3 tile_id = floor(point);
    vec3 tile_pos = fract(point);

    float min_dot = 10.0;
    for(float x = -1.0; x < 1.5; x++)
    {
        for(float y = -1.0; y < 1.5; y++)
        {
            for(float z = -1.0; z < 1.5; z++)
            {
                vec3 offset = vec3(x, y, z);
                vec3 diff = offset + random_vec3(tile_id + seed + offset) - tile_pos;
                float diff_dot = dot(diff, diff);
                
                if (min_dot > diff_dot)
                {
                    min_dot = diff_dot;
                    cell_id = tile_id + offset;
                }
            }
        }
    }

    return pow(min_dot, 1.0 / 3.0) * SQRT305;
}

//------------------------------------------------------
//------------------------------------------------------
//      VORONOI EDGE
//------------------------------------------------------
//------------------------------------------------------
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
        vec2 random_position = random_vec2(tile_id + offset + seed);
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
        vec2 random_position = random_vec2(tile_id + offset + seed);
        vec2 center = offset + random_position - tile_pos;

        vec2 edge = (nearest_center + center) * 0.5;
        float current_dot = dot(edge, normalize(center - nearest_center));

        min_dot = min(min_dot, current_dot);
    }

    return min_dot;
}

//------------------------------------------------------
//------------------------------------------------------
//      VORONOI MANHATTAN
//------------------------------------------------------
//------------------------------------------------------
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
            center = random_vec2(tile_id + seed + neighbour);
            dist = min(dist, value_manhatten_length(center - tile_pos + neighbour));
        }
    }

    return dist * 0.5;
}

//------------------------------------------------------
//------------------------------------------------------
//      LAYER EXTENSIONS
//------------------------------------------------------
//------------------------------------------------------
float noise_value(float point, float seed, float smoothness, int layers, float gain, float scale)
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

float noise_value(vec2 point, vec2 seed, float smoothness, int layers, float gain, float scale)
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

float noise_value(vec3 point, vec3 seed, float smoothness, int layers, float gain, float scale)
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

float noise_perlin(float point, float seed, int layers, float gain, float scale)
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

float noise_perlin(vec2 point, vec2 seed, int layers, float gain, float scale)
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

float noise_perlin(vec3 point, vec3 seed, int layers, float gain, float scale)
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

//------------------------------------------------------
//------------------------------------------------------
//      DIMENSION EXTENSIONS
//------------------------------------------------------
//------------------------------------------------------

// 2D value
vec2 noise_value_vec2(float point, float seed, float smoothness)
{
    return vec2(
        noise_value(point, seed++, smoothness),
        noise_value(point, seed, smoothness)
    );
}

vec2 noise_value_vec2(vec2 point, vec2 seed, float smoothness)
{
    return vec2(
        noise_value(point, seed++, smoothness),
        noise_value(point, seed, smoothness)
    );
}

vec2 noise_value_vec2(vec3 point, vec3 seed, float smoothness)
{
    return vec2(
        noise_value(point, seed++, smoothness),
        noise_value(point, seed++, smoothness)
    );
}

// 2D perlin
vec2 noise_perlin_vec2(float point, float seed)
{
    return vec2(
        noise_perlin(point, seed++),
        noise_perlin(point, seed)
    );
}

vec2 noise_perlin_vec2(vec2 point, vec2 seed)
{
    return vec2(
        noise_perlin(point, seed++),
        noise_perlin(point, seed)
    );
}

vec2 noise_perlin_vec2(vec3 point, vec3 seed)
{
    return vec2(
        noise_perlin(point, seed++),
        noise_perlin(point, seed)
    );
}

// 3D value
vec3 noise_value_vec3(float point, float seed, float smoothness)
{
    return vec3(
        noise_value(point, seed++, smoothness),
        noise_value(point, seed++, smoothness),
        noise_value(point, seed, smoothness)
    );
}

vec3 noise_value_vec3(vec2 point, vec2 seed, float smoothness)
{
    return vec3(
        noise_value(point, seed++, smoothness),
        noise_value(point, seed++, smoothness),
        noise_value(point, seed, smoothness)
    );
}

vec3 noise_value_vec3(vec3 point, vec3 seed, float smoothness)
{
    return vec3(
        noise_value(point, seed++, smoothness),
        noise_value(point, seed++, smoothness),
        noise_value(point, seed, smoothness)
    );
}

// 3D perlin
vec3 noise_perlin_vec3(float point, float seed)
{
    return vec3(
        noise_perlin(point, seed++),
        noise_perlin(point, seed++),
        noise_perlin(point, seed)
    );
}

vec3 noise_perlin_vec3(vec2 point, vec2 seed)
{
    return vec3(
        noise_perlin(point, seed++),
        noise_perlin(point, seed++),
        noise_perlin(point, seed)
    );
}

vec3 noise_perlin_vec3(vec3 point, vec3 seed)
{
    return vec3(
        noise_perlin(point, seed++),
        noise_perlin(point, seed++),
        noise_perlin(point, seed)
    );
}



// 2D value layered
vec2 noise_value_vec2(float point, float seed, float smoothness, int layers, float gain, float scale)
{
    return vec2(
        noise_value(point, seed++, smoothness, layers, gain, scale),
        noise_value(point, seed++, smoothness, layers, gain, scale)
    );
}

vec2 noise_value_vec2(vec2 point, vec2 seed, float smoothness, int layers, float gain, float scale)
{
    return vec2(
        noise_value(point, seed++, smoothness, layers, gain, scale),
        noise_value(point, seed++, smoothness, layers, gain, scale)
    );
}

vec2 noise_value_vec2(vec3 point, vec3 seed, float smoothness, int layers, float gain, float scale)
{
    return vec2(
        noise_value(point, seed++, smoothness, layers, gain, scale),
        noise_value(point, seed++, smoothness, layers, gain, scale)
    );
}

// 2D perlin layered
vec2 noise_perlin_vec2(float point, float seed, int layers, float gain, float scale)
{
    return vec2(
        noise_perlin(point, seed++, layers, gain, scale),
        noise_perlin(point, seed++, layers, gain, scale)
    );
}

vec2 noise_perlin_vec2(vec2 point, vec2 seed, int layers, float gain, float scale)
{
    return vec2(
        noise_perlin(point, seed++, layers, gain, scale),
        noise_perlin(point, seed++, layers, gain, scale)
    );
}

vec2 noise_perlin_vec2(vec3 point, vec3 seed, int layers, float gain, float scale)
{
    return vec2(
        noise_perlin(point, seed++, layers, gain, scale),
        noise_perlin(point, seed++, layers, gain, scale)
    );
}



// 3D value layered
vec3 noise_value_vec3(float point, float seed, float smoothness, int layers, float gain, float scale)
{
    return vec3(
        noise_value(point, seed++, smoothness, layers, gain, scale),
        noise_value(point, seed++, smoothness, layers, gain, scale),
        noise_value(point, seed++, smoothness, layers, gain, scale)
    );
}

vec3 noise_value_vec3(vec2 point, vec2 seed, float smoothness, int layers, float gain, float scale)
{
    return vec3(
        noise_value(point, seed++, smoothness, layers, gain, scale),
        noise_value(point, seed++, smoothness, layers, gain, scale),
        noise_value(point, seed++, smoothness, layers, gain, scale)
    );
}

vec3 noise_value_vec3(vec3 point, vec3 seed, float smoothness, int layers, float gain, float scale)
{
    return vec3(
        noise_value(point, seed++, smoothness, layers, gain, scale),
        noise_value(point, seed++, smoothness, layers, gain, scale),
        noise_value(point, seed++, smoothness, layers, gain, scale)
    );
}

// 3D perlin layered
vec3 noise_perlin_vec3(float point, float seed, int layers, float gain, float scale)
{
    return vec3(
        noise_perlin(point, seed++, layers, gain, scale),
        noise_perlin(point, seed++, layers, gain, scale),
        noise_perlin(point, seed++, layers, gain, scale)
    );
}

vec3 noise_perlin_vec3(vec2 point, vec2 seed, int layers, float gain, float scale)
{
    return vec3(
        noise_perlin(point, seed++, layers, gain, scale),
        noise_perlin(point, seed++, layers, gain, scale),
        noise_perlin(point, seed++, layers, gain, scale)
    );
}

vec3 noise_perlin_vec3(vec3 point, vec3 seed, int layers, float gain, float scale)
{
    return vec3(
        noise_perlin(point, seed++, layers, gain, scale),
        noise_perlin(point, seed++, layers, gain, scale),
        noise_perlin(point, seed++, layers, gain, scale)
    );
}


#endif
