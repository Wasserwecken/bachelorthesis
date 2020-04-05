#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"




vec2 provide_uv()
{
    vec2 uv = gl_FragCoord.xy / iResolution.y;

    return uv;
}

vec2 provide_uv_interactive()
{
    vec2 uv = gl_FragCoord.xy / iResolution.y;
    uv = uv * 2.0 - 1.0;
    
    vec2 mouse = iMouse.xy / iResolution.y;
    uv *= mouse.y;

    return uv;
}


void gravel(vec2 uv, vec2 seed, out vec3 albedo, out float roughness, out float height)
{
    uv *= 1.0;

    float gravel_roundness = 2.0;
    float gravel_height = 0.2;


    vec2 gravel_uv = uv;
    float gravel_distortion = noise_value(gravel_uv * 30.0, seed++, 1.0, 3, 0.5, 2.0);
    gravel_uv = uv_distort_twirl(gravel_uv, gravel_distortion, vec2(0.01), 0.1);


    vec2 top_id;
    float top = noise_voronoi_edge(gravel_uv, top_id, seed++);
    float top_exists = step(random(top_id + seed++), 0.3);
    top *= top_exists;
    top_id *= 0.1;
    top = clamp(top * (1.0 + random(top_id + seed++) * 2.5), 0.0, 1.0);
    top = easing_power_out(top, 1.0 + random(top_id + seed++) * gravel_roundness);
    top = value_remap(top, 0.0, 1.0, 0.7, 1.0);
    top -= random(top_id + seed++) * gravel_height;

    vec2 mid_id;
    float mid = noise_voronoi_edge(gravel_uv, mid_id, seed++);
    float mid_exists = step(random(mid_id + seed++), 0.6);
    mid *= mid_exists;
    mid = clamp(mid * (1.0 + random(mid_id + seed++) * 2.5), 0.0, 1.0);
    mid = easing_power_out(mid, 1.0 + random(mid_id + seed++) * gravel_roundness);
    mid = value_remap(mid, 0.0, 1.0, 0.35, 0.65);
    mid += (random(mid_id + seed++) * 2.0 - 1.0) * gravel_height;

    vec2 bottom_id;
    float bottom = noise_voronoi_edge(gravel_uv, bottom_id, seed++);
    bottom = clamp(bottom * (1.0 + random(bottom_id + seed++) * 2.5), 0.0, 1.0);
    bottom = easing_power_out(bottom, 1.0 + random(bottom_id + seed++) * gravel_roundness);
    bottom = value_remap(bottom, 0.0, 1.0, 0.0, 0.3);
    bottom += random(bottom_id + seed++) * gravel_height;
    

    vec2 gravel_id = bottom_id;
    float gravel = bottom;
    gravel = mix(gravel, mid, mid_exists);
    gravel_id = mix(gravel_id, mid_id, mid_exists);
    gravel = mix(gravel, top, top_exists);
    gravel_id = mix(gravel_id, top_id, top_exists);
    
    //float gravel_level = 7.0 * noise_perlin(uv * 0.1, seed++, 3, 0.5, 2.0);
    //gravel = (gravel + gravel_level) * 0.125;
    height = gravel;



    float roughness_base = random(gravel_id);
    float roughness_variation = noise_perlin(gravel_uv * 2.0, gravel_id);
    roughness = 0.5 * (roughness_base + roughness_variation);
    roughness = 0.5 + roughness * 0.5;
}



void stone_granit(vec2 uv, vec2 seed,
    out vec3 albedo,
    out float roughness,
    out float height,
    vec3 color_tint)
{
    vec2 grain_uv = uv * 7.0;

    // BASE
    vec2 distortion_id;
    vec2 dist_uv = grain_uv * 0.5;
    noise_voronoi(dist_uv, distortion_id, seed++);
    grain_uv = uv_distort_twirl(grain_uv, random(distortion_id), vec2(.2), 1.0);

    float quarz_share = 3.0;
    vec2 grain_id;
    float grain = noise_voronoi(grain_uv, grain_id, seed++);
    grain = random(grain_id);
    grain = easing_power_out(grain, quarz_share);
    grain = value_posterize(grain, 12.0);
    grain = easing_power_out(grain, 2.0);


    // COLOR
    float colored_grains = grain * 2.0 - 1.0;
    colored_grains = 1.0 - abs(colored_grains);

    float color_var_strength = .4;
    float color_var_power = 3.0;
    float color_var_uv_size = 2.0;
    float color_variation = noise_perlin(uv * color_var_uv_size, seed++, 2, 2.0, 10.0);
    color_variation = easing_power_inout(color_variation, color_var_power);
    color_variation = (color_variation * 2.0 - 1.0) * color_var_strength;
    colored_grains = clamp(colored_grains + color_variation, 0.0, 1.0);

    albedo = vec3(0.85 * grain);
    albedo = mix(albedo, color_tint * 0.5, colored_grains);


    // ROUGHNESS
    roughness = value_remap(random(grain_id), 0.0, 1.0, 0.8, 1.0);


    // HEIGHT
    float humps = noise_perlin(grain_uv * 0.7, seed++);
    humps = easing_power_inout(humps, 3.0);
    
    height = 0.5;
    height += random(grain_id) * 0.2 - 0.1;
    height += humps * 0.8 - 0.4;
}


void paving_stone(vec2 uv, vec2 seed, out vec3 albedo, out float roughness, out float height)
{

    vec2 tile_id;
    vec2 tile_uv;
    tile_uv = uv_tilling(uv, tile_id, vec2(10.0));

    float stone_offset = random(tile_id.y++ + seed++);
    tile_uv = uv_tilling_tile_offset(tile_uv, tile_id, stone_offset, 1.0);

    vec2 stone_size = vec2(0.75);
    float stone_blur = 0.1;
    float stone_corner = 0.2;
    vec2 stone_center = vec2(0.5);
    stone_center += 0.05 * (random_vec2(tile_id + seed++) * 2.0 - 1.0);

    float stone_uv_rot = 10.0 * (random(tile_id + seed++) * 2.0 - 1.0);
    float stone_uv_twirl = noise_perlin(
            tile_uv,
            tile_id,
            3, 0.5, 2.0
        );
    vec2 stone_uv = uv_distort_twirl(tile_uv, stone_uv_twirl, vec2(1.0), 0.05);
    stone_uv = uv_rotate(stone_uv, stone_center, stone_uv_rot);

    float stone = shape_rectangle_rounded(
            stone_uv,
            stone_center,
            stone_size,
            stone_blur,
            stone_corner
        );
    float stone_mask = step(0.001, stone);
    stone = easing_circular_out(stone);



    height = stone;
}


void main() {
    vec2 uv = provide_uv_interactive();
    float time_seed = floor(iTime * 0.25);
    time_seed = 1.0;

    vec3 albedo;
    float metallic;
    float roughness;
    float height;
    vec3 normal;

    //texture_old_parquet(uv, albedo, roughness, metallic, height, normal);
    //paving_stone(uv, time_seed, albedo, roughness, height);
    //gravel(uv, time_seed, albedo, roughness, height);
    stone_granit(uv, vec2(time_seed), albedo, roughness, height, vec3(.6, .5, .5));

    vec3 color = vec3(0.0);
    color = vec3(metallic);
    color = normal;
    color = albedo;
    color = vec3(roughness);
    color = vec3(height);

	gl_FragColor = vec4(color, 1.0);
}