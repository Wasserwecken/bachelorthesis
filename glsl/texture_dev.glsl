#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"

#include "/textures/simple.glsl"




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









void main() {
    vec2 uv = provide_uv_interactive();
    float time_seed = floor(iTime * 0.25);
    time_seed = 1.0;

    vec3 albedo;
    float metallic;
    float roughness;
    float height;
    float translucency;
    vec3 normal;

    //texture_old_parquet(uv, albedo, roughness, metallic, height, normal);
    //paving_stone(uv, vec2(time_seed), albedo, roughness, height);
    //gravel(uv, vec2(time_seed), albedo, roughness, height);
    //stone_granit(uv, vec2(time_seed), albedo, roughness, height, vec3(.6, .5, .5));
    simple_granit(uv, vec2(time_seed),
            albedo,
            roughness,
            height,
            translucency,
            vec3(.6, .5, .5), 7.0
        );

    vec3 color = vec3(0.0);
    color = vec3(metallic);
    color = normal;
    color = vec3(roughness);
    color = vec3(height);
    color = vec3(translucency);
    color = albedo;

	gl_FragColor = vec4(color, 1.0);
}