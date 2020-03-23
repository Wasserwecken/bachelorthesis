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





void paving_stone(vec2 uv, out vec3 albedo, out float metallic, out float roughness, out float height)
{

    vec2 tile_id;
    vec2 tile_uv;
    tile_uv = uv_tilling(uv, tile_id, vec2(10.0));

    float stone_offset = noise_white(tile_id.y++);
    tile_uv = uv_tilling_tile_offset(tile_uv, tile_id, stone_offset, 1.0);

    vec2 stone_size = vec2(0.75);
    float stone_blur = 0.1;
    float stone_corner = 0.2;
    vec2 stone_center = vec2(0.5);
    stone_center += 0.05 * (noise_white_vec2(tile_id) * 2.0 - 1.0);

    float stone_uv_rot = 10.0 * (noise_white(tile_id) * 2.0 - 1.0);
    float stone_uv_twirl = noise_perlin_layered(
            tile_uv,
            tile_id,
            3, 0.5, 2.0
        );
    vec2 stone_uv = uv_distort_twirl(tile_uv, vec2(1.0), stone_uv_twirl, 0.05);
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





    //float stone_surface = stone_mask;
    //stone_surface *= 0.5 * noise_perlin_layered(tile_uv, tile_id, 2, 0.5, 2.0);
    //stone -= stone_surface;
    //
    //dirt *= 1.0 - stone_mask;+



    float gravel = .5;





    height = gravel;
}


void main() {
    vec2 uv = provide_uv();

    vec3 albedo;
    float metallic;
    float roughness;
    float height;
    vec3 normal;

    //texture_old_parquet(uv, albedo, roughness, metallic, height, normal);
    paving_stone(uv, albedo, roughness, metallic, height);

    vec3 color = vec3(0.0);
    color = vec3(metallic);
    color = normal;
    color = vec3(roughness);
    color = albedo;
    color = vec3(height);

	gl_FragColor = vec4(color, 1.0);
}