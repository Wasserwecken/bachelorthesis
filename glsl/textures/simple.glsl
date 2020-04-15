#include "../framework/constants.glsl"
#include "../framework/helper.glsl"
#include "../framework/easing.glsl"
#include "../framework/shapes.glsl"
#include "../framework/noise.glsl"
#include "../framework/uv.glsl"
#include "../framework/color.glsl"

#ifndef SIMPLE
#define SIMPLE


void simple_granit(
    vec2 uv,
    vec2 seed,
    out vec3 albedo,
    float quartz_strength,
    vec3 color_base,
    vec3 color_tint)
{
    // GRAIN
    vec2 grain_id;
    vec2 grain_center;
    vec2 grain_uv = uv * 7.0;
    noise_voronoi(grain_uv, grain_id, grain_center, seed++, vec2(1.0));
    float grain = random(grain_id);
    grain = value_posterize(grain, 12.0);
    grain = easing_power_out(grain, quartz_strength);


    // COLOR
    float colored_grains = grain * 2.0 - 1.0;
    colored_grains = 1.0 - abs(colored_grains);
    albedo = vec3(color_base * grain);
    albedo = mix(albedo, color_tint * 0.5, colored_grains);
}

void complex_granit(
    vec2 uv,
    vec2 seed,
    out vec3 albedo,
    float quartz_strength,
    vec3 color_base,
    vec3 color_tint,
    float turbulence_visibility)
{
    uv * 0.5;

    // GRAIN
    vec2 dist_id;
    vec2 dist_center;
    vec2 grain_id;
    vec2 grain_center;
    vec2 grain_uv = uv * 7.0;

    noise_voronoi(grain_uv, dist_id, dist_center, seed++, vec2(1.0));
    grain_uv = uv_distort_twirl(grain_uv, random(dist_id), vec2(0.5), 0.5);

    noise_voronoi(grain_uv, grain_id, grain_center, seed++, vec2(1.0));
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
    vec2 turb_uv = uv * 0.04;

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


void simple_marmor(
    vec2 uv,
    vec2 seed,
    out vec3 albedo,
    vec3 crack_color,
    vec3 fill_color,
    float crack_intensity,
    float crack_occlusion)
{    
    vec2 crack_uv = uv * 0.5;
    float cracks = noise_value(crack_uv, seed++, 1.5, 6, 0.4, 2.5);
    cracks = noise_creases(cracks);
    cracks = easing_power_in(cracks, crack_intensity);

    vec2 occlusion_uv = crack_uv * 1.5;
    float occlusion = noise_perlin(occlusion_uv, seed++);
    occlusion = easing_power_inout(occlusion, crack_occlusion);
    cracks *= occlusion;

    albedo = mix(fill_color, crack_color, cracks);
}

void simple_limestone(
        vec2 uv,
        vec2 seed,
        out vec3 albedo,
        vec3 color_base,
        float color_turbulence)
{
    vec2 color_uv = (1.0 - uv.yx) * 2.0;
    float turbulence_strength = color_turbulence;
    float color_distribution = noise_value(color_uv, seed++, 1.5, 5, 0.5, 3.0);
    float d1 = easing_power_out(color_distribution, turbulence_strength);
    float d2 = easing_power_in(color_distribution, turbulence_strength);

    albedo = mix(vec3(1.0), color_base, d1);
    albedo -= d2 * 0.4;
}

void simple_pebble(
        vec2 uv,
        vec2 seed,
        out vec3 albedo,
        out float height,
        vec3 color_base,
        float color_turbulence)
{


    vec2 distortion_uv = uv * 0.25;
    float distortion = noise_value(distortion_uv, seed++, 1.5, 3, 0.7, 1.8);
    uv += (distortion - 1.0) * 0.2;

    float size = value_remap_01(random(seed++), 0.05, 0.15);
    height = shape_circle(uv, vec2(0.5), size, size * 2.0);
    height = easing_circular_out(height);

    vec2 color_uv = (1.0 - uv.yx) * 2.0;

    simple_limestone(color_uv, seed++, albedo, color_base, color_turbulence);
    albedo *= step(0.01, height);
}



#endif