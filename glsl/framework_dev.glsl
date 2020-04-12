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


void main() {
    vec2 uv = provide_uv();
    float time_seed = 1.0;
    //time_seed += floor(iTime * 0.25);

    vec2 id;
    vec3 color = vec3(1.0);
    //color = test_pattern(uv);


    float x = uv.x;
    float e = x;

    e = easing_smooth(x, 5);
    e = easing_power_in(x, 3.0);
    e = easing_power_out(x, 3.0);
    e = easing_power_inout(x, 3.0);
    e = easing_circular_in(x);
    e = easing_circular_out(x);
    e = easing_circular_inout(x);
    e = easing_sinus_in(x);
    e = easing_sinus_out(x);
    e = easing_sinus_inout(x);
    e = easing_expo_in(x);
    e = easing_expo_out(x);
    e = easing_expo_inout(x);

    e = value_linear_step(e, uv.y, 0.005);

    //e = noise_perlin(uv, vec2(time_seed));
    //e = noise_value(uv, vec2(time_seed), 2.0);
    //e = noise_voronoi(uv, id, vec2(time_seed));

    color = vec3(e);
    
	gl_FragColor = vec4(color, 1.0);
}