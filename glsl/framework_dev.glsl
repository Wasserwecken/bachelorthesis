#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"

#include "/textures/colortestpattern.glsl"


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

float noise_creases(float noise)
{
    noise = abs(noise * 2.0 -1.0);
    noise = 1.0 - noise;
    noise *= noise * noise * noise * noise * noise;

    return noise;
}






void main() {

    vec2 uv = provide_uv();
    float time_seed = 1.0 + floor(iTime * 0.25);

    vec3 color = vec3(1.0);
    //color = test_pattern(uv);


    vec3 id;
    float n = noise_voronoi(vec3(uv, iTime * 0.02), id, vec3(1.0));
    color *= random(id);
    color = vec3(n);

    
	gl_FragColor = vec4(color, 1.0);
}