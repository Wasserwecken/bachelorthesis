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
    vec2 uv = gl_FragCoord.xy / iResolution.xy;

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
    vec2 time_seed = vec2(1.0 + floor(iTime * 0.5));

    vec3 color = vec3(1.0);
    //color = test_pattern(uv);




    float nA = noise_perlin(uv.x, time_seed.x++, 3, 0.5, 2.0);
    float nB = noise_perlin(uv.x, time_seed.x++, 3, 0.5, 2.0);
    float nC = noise_perlin(uv.x, time_seed.x++, 3, 0.5, 2.0);
    nA = easing_power_inout(nA, 3.0);

    vec3 baseCol = random_vec3(time_seed);
    vec3 col = color_hsv_shift(baseCol, nA, nB, nC);
    color *= nA;
    color = col;

    float z = iTime * 0.1;
    vec3 n = noise_perlin_vec3(vec3(uv * 1.0, z), vec3(1.0), 4, .5, 2.);
    n = easing_power_inout(n, vec3(3.0));
    color = vec3(n);




    
	gl_FragColor = vec4(color, 1.0);
}