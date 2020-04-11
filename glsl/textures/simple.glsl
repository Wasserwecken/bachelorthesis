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


    // COLOR
    float colored_grains = grain * 2.0 - 1.0;
    colored_grains = 1.0 - abs(colored_grains);
    albedo = vec3(color_base * grain);
    albedo = mix(albedo, color_tint * 0.5, colored_grains);
}

void complex_granit(vec2 uv, vec2 seed,
    out vec3 albedo,
    float quartz_strength,
    vec3 color_base,
    vec3 color_tint,
    float turbulence_visibility)
{

    // GRAIN
    float grain_scale = 25.0;
    vec2 dist_id;
    vec2 grain_id;
    vec2 grain_uv = uv * grain_scale;

    noise_voronoi(uv * grain_scale, dist_id, seed++);
    grain_uv = uv_distort_twirl(grain_uv, random(dist_id), vec2(0.5), 0.5);

    noise_voronoi(grain_uv, grain_id, seed++);
    float grain = random(grain_id);
    grain = value_posterize(grain, 12.0);
    grain = easing_power_out(grain, quartz_strength);
    grain += (random(grain_id++) * 2.0 - 1.0) * 0.05;


    // GRAIN COLOR
    float colored_grains = grain * 2.0 - 1.0;
    colored_grains = 1.0 - abs(colored_grains);
    vec3 color_grain;
    color_grain = vec3(color_base * grain);
    color_grain = mix(color_grain, color_tint * 0.5, colored_grains);

    // COLOR TURBULENCE
    int turb_iterations = 4;
    float turb_strength = 0.1;
    vec2 turb_uv = uv * 0.25;

    vec2 turb_noise = noise_perlin_vec2(turb_uv * 0.5, seed++);
    turb_uv += turb_noise * turb_strength;

    turb_noise = noise_perlin_vec2(turb_uv * 2.0, seed++, turb_iterations, 0.5, 2.0);
    turb_noise = noise_vallies(turb_noise);
    turb_uv += turb_noise * turb_strength;

    float turb_gradient = noise_perlin(turb_uv, seed++, turb_iterations, 0.5, 2.0);
    turb_gradient = easing_power_inout(turb_gradient, 4.0);

    vec3 turb_color1 = color_base;
    vec3 turb_color2 = color_tint;
    vec3 turb_color3 = turb_color2 * 0.2;
    
    vec3 color_turbulence;
    color_turbulence = mix(turb_color1, turb_color2, turb_gradient);
    color_turbulence = mix(color_turbulence, turb_color3, turb_noise.x);
    color_turbulence = mix(color_turbulence, turb_color3, length(turb_noise));
    color_turbulence = mix(vec3(1.0), color_turbulence, turbulence_visibility);

    albedo = color_grain * color_turbulence;
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