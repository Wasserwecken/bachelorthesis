#include "../framework/constants.glsl"
#include "../framework/helper.glsl"
#include "../framework/easing.glsl"
#include "../framework/shapes.glsl"
#include "../framework/noise.glsl"
#include "../framework/uv.glsl"
#include "../framework/color.glsl"

#include "simple.glsl"

#ifndef COMPOUND
#define COMPOUND



void compound_paving_stone(
        vec2 uv,
        vec2 seed,
        out vec3 albedo,
        out float roughness,
        out float height)
{
    vec2 stone_id;
    vec2 stone_uv = uv;
    stone_uv = uv_tilling(stone_uv, stone_id, vec2(10.0));
    float offset = random(stone_id.y);
    stone_uv = uv_tilling_tile_offset(stone_uv, stone_id, offset, 1.0);

    vec2 distortion_uv = stone_uv * 0.25;
    float stone_distortion = noise_perlin(distortion_uv, stone_id + seed++, 3, 0.5, 2.0);
    float stone_rotation = (random(stone_id + seed++) * 2.0 - 1.0) * 7.0;
    stone_uv = uv_rotate(stone_uv, vec2(0.5), stone_rotation);
    stone_uv = uv_distort_twirl(stone_uv, stone_distortion, vec2(0.3), 0.3);

    height = stone_distortion;

    vec2 stone_origin = vec2(0.5);
    vec2 stone_size = vec2(0.8);
    float stone_blur = 0.1;
    vec4 stone_edge = vec4(0.15);
    float stone = shape_rectangle_rounded(stone_uv, stone_origin, stone_size, stone_blur, stone_edge);
    float stone_mask = step(0.01, stone);

    float stone_height = easing_circular_out(stone);
    stone_height *= stone_distortion;
    stone_height = value_remap_01(stone_height, 0.0, 1.0);
    stone_height *= stone_mask;


    vec2 gravel_uv = uv * 4.0;
    vec3 gravel_albedo;
    float gravel_roughness;
    float gravel_height;
    simple_gravel(gravel_uv, seed++, gravel_albedo, gravel_roughness, gravel_height);
    gravel_height = value_remap_01(gravel_height, 0.0, 0.5);

    vec3 stone_albedo;
    simple_granit(stone_uv, stone_id + seed++, stone_albedo, 7.0, vec3(1.0), vec3(0.7));


    albedo = mix(gravel_albedo, stone_albedo, stone_mask);
    height = mix(gravel_height, stone_height, stone_mask);
}




#endif