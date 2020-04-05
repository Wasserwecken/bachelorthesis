#include "../framework/constants.glsl"
#include "../framework/helper.glsl"
#include "../framework/easing.glsl"
#include "../framework/shapes.glsl"
#include "../framework/noise.glsl"
#include "../framework/uv.glsl"
#include "../framework/color.glsl"

#ifndef SIMPLE
#define SIMPLE

void simple_granit(vec2 uv, vec2 seed,
    out vec3 albedo,
    out float roughness,
    out float height,
    out float translucency,
    vec3 color_tint,
    float quartz_strength)
{
    // GRAIN
    vec2 grain_uv = uv * 7.0;
    vec2 grain_id;
    float grain = noise_voronoi(grain_uv, grain_id, seed++);
    grain = random(grain_id);
    grain = value_posterize(grain, 12.0);
    grain = easing_power_out(grain, quartz_strength);


    // COLOR
    float colored_grains = grain * 2.0 - 1.0;
    colored_grains = 1.0 - abs(colored_grains);

    albedo = vec3(0.85 * grain);
    albedo = mix(albedo, color_tint * 0.5, colored_grains);

    roughness = value_remap(random(grain_id), 0.0, 1.0, 0.3, 0.7);
    height = noise_perlin(uv * 7.0, seed++);
    translucency = grain * 0.5;
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