#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"
#include "/textures/processed_wood.glsl"




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
    vec2 stone_id;
    vec2 stone_uv;
    stone_uv = uv_tilling_01(uv, stone_id, vec2(5.0));

    float stone = shape_rectangle(stone_uv, vec2(0.5), vec2(0.85), vec2(0.05));

    albedo = vec3(1.0) * stone;
}


void main() {
    vec2 uv = provide_uv_interactive();

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
    color = vec3(height);
    color = albedo;

	gl_FragColor = vec4(color, 1.0);
}