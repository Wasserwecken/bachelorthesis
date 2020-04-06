#include "../framework/constants.glsl"
#include "../framework/helper.glsl"
#include "../framework/easing.glsl"
#include "../framework/shapes.glsl"
#include "../framework/noise.glsl"
#include "../framework/uv.glsl"
#include "../framework/color.glsl"

#ifndef SIMPLE
#define SIMPLE


//simple_granit(uv, vec2(time_seed), albedo, roughness, height, 
//    8.0, vec3(1.0, 0.95, 0.9), vec3(0.6, 0.1, 0.1)); 
//    2.0, vec3(0.9), vec3(0.1)); 
//    10.0, vec3(0.95), vec3(0.5);
void simple_granit(vec2 uv, vec2 seed,
    out vec3 albedo,
    out float roughness,
    out float height,
    float quartz_strength,
    vec3 color_base,
    vec3 color_tint)
{
    // GRAIN
    vec2 grain_id;
    vec2 grain_uv = uv * 7.0;
    noise_voronoi(grain_uv, grain_id, seed++);
    float grain = random(grain_id);
    grain = value_posterize(grain, 12.0);
    grain = easing_power_out(grain, quartz_strength);


    // HEIGHT
    float height_easing = 3.0;
    height = noise_perlin(uv * 0.2, seed++, 7, 0.7, 1.8);
    height = easing_power_inout(height, height_easing);
    height = easing_power_in(height, height_easing);


    // COLOR
    float colored_grains = grain * 2.0 - 1.0;
    colored_grains = 1.0 - abs(colored_grains);
    albedo = vec3(color_base * grain);
    albedo = mix(albedo, color_tint * 0.5, colored_grains);


    // ROUGHNESS
    roughness = easing_power_in(1.0 - height, 5.0);
}


void simple_limestone(vec2 uv, vec2 seed)
{

}

void simple_marmor(vec2 uv, vec2 seed)
{
    
}

void simple_sandstone(vec2 uv, vec2 seed)
{
    
}

void simple_slate(vec2 uv, vec2 seed)
{
    
}

void simple_gneis(vec2 uv, vec2 seed)
{
    
}





#endif