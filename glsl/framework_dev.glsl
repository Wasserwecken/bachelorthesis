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


float shape_gradient(vec2 uv, vec2 direction)
{
    direction = -direction;
    uv = vec2(0.5) - uv;

    float stretch = dot(direction, direction);
    float gradient = dot(uv, direction);

    return gradient / stretch + 0.5;
}



void main() {

    vec2 uv = provide_uv();
    vec2 time_seed = vec2(floor(iTime * 0.5));


    vec3 color = vec3(1.0);




    float foo = shape_gradient(uv, vec2(0.5, 0.0));


    color *= foo;

    


    
	gl_FragColor = vec4(color, 1.0);
}