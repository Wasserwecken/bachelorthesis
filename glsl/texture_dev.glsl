#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"
#include "/textures/processed_wood.glsl"





void pattern(vec2 uv, out vec3 albedo, out float metallic, out float roughness, out float height, out vec3 normal)
{
    vec2 foo = fract(uv * 20.0);
    height = foo.x * foo.y;
}






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

    vec3 albedo;
    float metallic;
    float roughness;
    float height;
    vec3 normal;


    //texture_old_parquet(uv * .5 + 0.9, albedo, metallic, roughness, height, normal);
    pattern(uv, albedo, metallic, roughness, height, normal);

    vec3 color = vec3(0.0);
    color = vec3(metallic);
    color = normal;
    color = albedo;
    color = vec3(roughness);
    color = vec3(height);

	gl_FragColor = vec4(color, 1.0);
}