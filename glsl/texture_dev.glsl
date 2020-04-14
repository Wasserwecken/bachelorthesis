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

void simple_gravel(
        vec2 uv,
        vec2 seed,
        out vec3 albedo,
        out float roughness,
        out float height)
{
    vec2 id;
    uv = uv_tilling(uv, id, vec2(20.0));

    simple_pebble(uv, random_vec2(seed + id), albedo, height,
            color_hex(0x809085),
            7.0
        );
}




void main() {
    vec2 uv = provide_uv_interactive();
    float time_seed = floor(iTime * 0.25);
    time_seed = 1.0;
    vec2 time_seed2 = vec2(time_seed);

    vec3 albedo;
    float metallic;
    float roughness;
    float height;
    float translucency;
    vec3 normal;

    //complex_granit(uv * 10.0, time_seed2, albedo, 10.0, vec3(1.0), vec3(0.1), 1.0);
    //simple_granit(uv * 10.0, time_seed2, albedo, 10.0, vec3(1.0), vec3(0.1));

    //simple_marmor(uv, time_seed2, albedo, vec3(0.0), vec3(1.0), 20.0, 5.0);
    //simple_pebble(uv, time_seed2, albedo, height, color_hex(0x809085));

    simple_gravel(uv, time_seed2, albedo, roughness, height);

    //compound_paving_stone(uv, time_seed2, albedo, roughness, height);



    vec3 color = vec3(0.0);
    color = vec3(metallic);
    color = normal;
    color = vec3(translucency);
    color = vec3(roughness);
    color = vec3(height);
    color = albedo;

	gl_FragColor = vec4(color, 1.0);
}