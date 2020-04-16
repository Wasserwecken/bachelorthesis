#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/noise.extensions.glsl"
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
    vec2 uv = provide_uv_interactive();
    float time_seed = 1.0;
    //time_seed += floor(iTime * 0.25);

    vec2 time_seed2 = vec2(time_seed);
    vec3 time_seed3 = vec3(time_seed);

    vec2 id;
    vec3 color = vec3(1.0);
    //color = test_pattern(uv);


    vec2 a, b;
    float c;
    float n = noise_voronoi_edge(uv, time_seed2, a, b, c, vec2(sin(iTime) * 0.5 + 0.5));
    color = vec3(1.0) * n * 1.5 * step( 0.05, c);

    float s = shape_circle(uv, vec2(b), 0.003, 0.0);
    color += vec3(1.0) * s;
    
	gl_FragColor = vec4(color, 1.0);
}