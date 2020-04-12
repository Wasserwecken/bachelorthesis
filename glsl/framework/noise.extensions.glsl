#include "constants.glsl"
#include "random.glsl"
#include "helper.glsl"
#include "easing.glsl"
#include "noise.glsl"

#ifndef NOISE_EXT
#define NOISE_EXT

//------------------------------------------------------
//------------------------------------------------------
//      FBM EXTENSIONS
//------------------------------------------------------
//------------------------------------------------------
float noise_value(
        float point,
        float seed,
        float smoothness,
        int layers,
        float gain,
        float scale)
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

float noise_value(
        vec2 point,
        vec2 seed,
        float smoothness,
        int layers,
        float gain,
        float scale)
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

float noise_value(
        vec3 point,
        vec3 seed,
        float smoothness,
        int layers,
        float gain,
        float scale)
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

float noise_perlin(
        float point,
        float seed,
        int layers,
        float gain,
        float scale)
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

float noise_perlin(
        vec2 point,
        vec2 seed,
        int layers,
        float gain,
        float scale)
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

float noise_perlin(
        vec3 point,
        vec3 seed,
        int layers,
        float gain,
        float scale)
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

float noise_voronoi(
        float point,
        out float cell_id,
        out float center_id,
        float seed,
        float strength,
        int layers,
        float gain,
        float scale)
{
    point *= LAYERED_SCALE;

    float result = 0.0;
    float height_sum = 0.0;
    
    float frequency = 1.0;
    float amplitude = 1.0;

    float id;
    float center;

    for(int layer = 0; layer < layers; layer++)
    {
        result += noise_voronoi(
                point * frequency,
                id, center,
                seed++, strength
            ) * amplitude;
        
        height_sum += amplitude;
        frequency *= scale;
        amplitude *= gain;

        float digit = pow(10.0, -float(layer));
        cell_id += digit * id;
        center_id += digit * center;
    }

    return result / height_sum;
}

float noise_voronoi(
        vec2 point,
        out vec2 cell_id,
        out vec2 center_id,
        vec2 seed,
        vec2 strength,
        int layers,
        float gain,
        float scale)
{
    point *= LAYERED_SCALE;

    float result = 0.0;
    float height_sum = 0.0;
    
    float frequency = 1.0;
    float amplitude = 1.0;

    vec2 id;
    vec2 center;

    for(int layer = 0; layer < layers; layer++)
    {
        result += noise_voronoi(
                point * frequency,
                id, center,
                seed++, strength
            ) * amplitude;
        
        height_sum += amplitude;
        frequency *= scale;
        amplitude *= gain;

        float digit = pow(10.0, -float(layer));
        cell_id += digit * id;
        center_id += digit * center;
    }

    return result / height_sum;
}

float noise_voronoi(
        vec3 point,
        out vec3 cell_id,
        out vec3 center_id,
        vec3 seed,
        vec3 strength,
        int layers,
        float gain,
        float scale)
{
    point *= LAYERED_SCALE;

    float result = 0.0;
    float height_sum = 0.0;
    
    float frequency = 1.0;
    float amplitude = 1.0;

    vec3 id;
    vec3 center;

    for(int layer = 0; layer < layers; layer++)
    {
        result += noise_voronoi(
                point * frequency,
                id, center,
                seed++, strength
            ) * amplitude;
        
        height_sum += amplitude;
        frequency *= scale;
        amplitude *= gain;

        float digit = pow(10.0, -float(layer));
        cell_id += digit * id;
        center_id += digit * center;
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



// 2D voronoi
vec2 noise_voronoi_vec2(float point, out float cell_id, out float center_id, float seed, float strength)
{
    return vec2(
        noise_voronoi(point, cell_id, center_id, seed++, strength),
        noise_voronoi(point, cell_id, center_id, seed++, strength)
    );
}

vec2 noise_perlin_vec2(vec2 point, out vec2 cell_id, out vec2 center_id, vec2 seed, vec2 strength)
{
    return vec2(
        noise_voronoi(point, cell_id, center_id, seed++, strength),
        noise_voronoi(point, cell_id, center_id, seed++, strength)
    );
}

vec2 noise_perlin_vec2(vec3 point, out vec3 cell_id, out vec3 center_id, vec3 seed, vec3 strength)
{
    return vec2(
        noise_voronoi(point, cell_id, center_id, seed++, strength),
        noise_voronoi(point, cell_id, center_id, seed++, strength)
    );
}

// 3D voronoi
vec3 noise_voronoi_vec3(float point, out float cell_id, out float center_id, float seed, float strength)
{
    return vec3(
        noise_voronoi(point, cell_id, center_id, seed++, strength),
        noise_voronoi(point, cell_id, center_id, seed++, strength),
        noise_voronoi(point, cell_id, center_id, seed++, strength)
    );
}

vec3 noise_voronoi_vec3(vec2 point, out vec2 cell_id, out vec2 center_id, vec2 seed, vec2 strength)
{
    return vec3(
        noise_voronoi(point, cell_id, center_id, seed++, strength),
        noise_voronoi(point, cell_id, center_id, seed++, strength),
        noise_voronoi(point, cell_id, center_id, seed++, strength)
    );
}

vec3 noise_voronoi_vec3(vec3 point, out vec3 cell_id, out vec3 center_id, vec3 seed, vec3 strength)
{
    return vec3(
        noise_voronoi(point, cell_id, center_id, seed++, strength),
        noise_voronoi(point, cell_id, center_id, seed++, strength),
        noise_voronoi(point, cell_id, center_id, seed++, strength)
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



// 2D voronoi layered
vec2 noise_voronoi_vec2(float point, out float cell_id, out float center_id, float seed, float strength, int layers, float gain, float scale)
{
    return vec2(
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale),
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale)
    );
}

vec2 noise_perlin_vec2(vec2 point, out vec2 cell_id, out vec2 center_id, vec2 seed, vec2 strength, int layers, float gain, float scale)
{
    return vec2(
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale),
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale)
    );
}

vec2 noise_perlin_vec2(vec3 point, out vec3 cell_id, out vec3 center_id, vec3 seed, vec3 strength, int layers, float gain, float scale)
{
    return vec2(
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale),
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale)
    );
}

// 3D voronoi layered
vec3 noise_voronoi_vec3(float point, out float cell_id, out float center_id, float seed, float strength, int layers, float gain, float scale)
{
    return vec3(
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale),
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale),
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale)
    );
}

vec3 noise_voronoi_vec3(vec2 point, out vec2 cell_id, out vec2 center_id, vec2 seed, vec2 strength, int layers, float gain, float scale)
{
    return vec3(
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale),
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale),
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale)
    );
}

vec3 noise_voronoi_vec3(vec3 point, out vec3 cell_id, out vec3 center_id, vec3 seed, vec3 strength, int layers, float gain, float scale)
{
    return vec3(
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale),
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale),
        noise_voronoi(point, cell_id, center_id, seed++, strength, layers, gain, scale)
    );
}

#endif