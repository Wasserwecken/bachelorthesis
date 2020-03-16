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



void main() {

    vec2 uv = provide_uv();
    vec3 color = vec3(0.0);

    color = pattern1(uv);
    uv = value_posterize(uv, vec2(40.0));
    color = color_deviate(color, vec3(uv, 0.0), vec3(sin(iTime*0.5)));


	gl_FragColor = vec4(color, 1.0);
}