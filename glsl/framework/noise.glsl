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
    point += random(seed++) - 1.0;
    point *= NOISE_SCALE;

    float corner = floor(point);
    float interpolation = easing_power_inout(fract(point), smoothness);

    float A = random(corner + 0.0 + seed);
    float B = random(corner + 1.0 + seed);

    return mix(A, B, interpolation);
}

float noise_value(vec2 point, vec2 seed, float smoothness)
{
    point += random_vec2(seed++) - 1.0;
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
    point += random_vec3(seed++) - 1.0;
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
    point += random(seed++) - 1.0;
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
    point += random_vec2(seed++) - 1.0;
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
    point += random_vec3(seed++) - 1.0;
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
float noise_voronoi(
        float point,
        out float cell_id,
        out float cell_center,
        float seed,
        float strength)
{
    point += random(seed++) - 1.0;
    point *= NOISE_SCALE;

    float tile_id = floor(point);
    float tile_pos = fract(point);

    float min_diff = 10.0;
    for(float x = -0.5; x < 2.0; x++)
    {
        float random_point = random(tile_id + seed + x);
        float center = x + (random_point - 0.5) * strength;
        float diff = center - tile_pos;
        diff = abs(diff);
        
        if (min_diff > diff)
        {
            min_diff = diff;
            cell_id = tile_id + x;
            cell_center = tile_id + center;
        }
    }

    cell_center /= NOISE_SCALE;
    return min_diff;
}

float noise_voronoi(
        vec2 point,
        out vec2 cell_id,
        out vec2 cell_center,
        vec2 seed,
        vec2 strength)
{
    point += random_vec2(seed++) - 1.0;
    point *= NOISE_SCALE;

    vec2 tile_id = floor(point);
    vec2 tile_pos = fract(point);

    float min_dot = 10.0;
    for(float x = -0.5; x < 2.0; x++)
    {
        for(float y = -0.5; y < 2.0; y++)
        {
            vec2 offset = vec2(x, y);
            vec2 random_point = random_vec2(tile_id + seed + offset);
            vec2 center = offset + (random_point - 0.5) * strength;
            vec2 diff = center - tile_pos;
            float diff_dot = dot(diff, diff);
            
            if (min_dot > diff_dot)
            {
                min_dot = diff_dot;
                cell_id = tile_id + offset;
                cell_center = tile_id + center;
            }
        }
    }

    cell_center /= NOISE_SCALE;
    return sqrt(min_dot) * SQRT205;
}

float noise_voronoi(
        vec3 point,
        out vec3 cell_id,
        out vec3 cell_center,
        vec3 seed,
        vec3 strength)
{
    point += random_vec3(seed++) - 1.0;
    point *= NOISE_SCALE;

    vec3 tile_id = floor(point);
    vec3 tile_pos = fract(point);

    float min_dot = 10.0;
    for(float x = -0.5; x < 2.0; x++)
    {
        for(float y = -0.5; y < 2.0; y++)
        {
            for(float z = -0.5; z < 2.0; z++)
            {
                vec3 offset = vec3(x, y, z);
                vec3 random_point = random_vec3(tile_id + seed + offset);
                vec3 center = offset + (random_point - 0.5) * strength;
                vec3 diff = center - tile_pos;
                float diff_dot = dot(diff, diff);
                
                if (min_dot > diff_dot)
                {
                    min_dot = diff_dot;
                    cell_id = tile_id + offset;
                    cell_center = tile_id + center;
                }
            }
        }
    }

    cell_center /= NOISE_SCALE;
    return pow(min_dot, 1.0 / 3.0) * SQRT305;
}

//------------------------------------------------------
//------------------------------------------------------
//      VORONOI EDGE
//------------------------------------------------------
//------------------------------------------------------
//https://www.iquilezles.org/www/articles/voronoilines/voronoilines.htm
//https://www.ronja-tutorials.com/2018/09/29/voronoi-noise.html
float noise_voronoi(
        vec2 point,
        vec2 seed,
        out vec2 cell_id,
        out vec2 cell_center,
        out float dist,
        vec2 strength)
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


#endif
