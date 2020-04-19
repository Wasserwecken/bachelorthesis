#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"

#include "/textures/simple.glsl"
#include "/textures/compound.glsl"




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







void compound_paving_stone(
        vec2 uv,
        vec2 seed,
        out vec3 albedo,
        out float roughness,
        out float height)
{
    vec2 stone_id;
    uv = uv_tilling(uv, stone_id, vec2(10.0));

    float stone_distortion = noise_perlin(uv, stone_id + seed++);
    vec2 stone_origin = vec2(0.5);
    vec2 stone_size = vec2(0.5);
    float stone_blur = 0.1;
    vec2 stone_uv = uv_distort_twirl(uv, stone_distortion, vec2(0.2), 0.3);
    float stone = 0.0;// shape_rectangle_rounded(stone_uv, stone_origin, stone_size, stone_blur, 0.1);

    albedo = vec3(uv, 0.0);
    albedo = stone * vec3(1.0);
}



void main() {
    vec2 uv = provide_uv();
    float time_seed = floor(iTime * 0.25);
    time_seed = 1.0;
    vec2 time_seed2 = vec2(time_seed);

    vec3 albedo;
    float metallic;
    float roughness;
    float translucency;
    vec3 normal;
    float height;

    //complex_granit(uv * 10.0, time_seed2, albedo, 10.0, vec3(1.0), vec3(0.1), 1.0);
    //simple_granit(uv * 10.0, time_seed2, albedo, 10.0, vec3(1.0), vec3(0.1));

    //simple_marmor(uv, time_seed2, albedo, vec3(0.0), vec3(1.0), 20.0, 5.0);
    //simple_limestone(uv, time_seed2, albedo, color_hex(0x809085), 7.0);

    //simple_gravel(uv, time_seed2, albedo, roughness, height);

    //compound_paving_stone(uv, time_seed2, albedo, roughness, height);


    height = shape_rectangle_rounded(uv, vec2(0.5), vec2(0.7), 0.1, vec4(0.1));

    vec3 color = vec3(0.0);
    color = vec3(metallic);
    color = normal;
    color = vec3(translucency);
    color = vec3(roughness);
    color = albedo;
    color = vec3(height);

	gl_FragColor = vec4(color, 1.0);
}