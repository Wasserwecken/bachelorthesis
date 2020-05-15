#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/noise.fbm.glsl"
#include "/framework/noise.dimensions.glsl"
#include "/framework/uv.glsl"


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



    vec3 color = vec3(1.0);
    //color = test_pattern(uv);


    
	gl_FragColor = vec4(color, 1.0);
}