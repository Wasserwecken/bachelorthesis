#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"


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


vec3 easing_tests()
{
    vec2 uv = provide_uv();
    vec3 color = vec3(0.0);

    float r = easing_power_inout(uv.x, 10.0);
    float g = easing_smoother_step(uv.x);
    float b = easing_smoother_step(g);

    color.r = step(uv.y, r);
    color.g = step(uv.y, g);
    color.b = step(uv.y, b);

    return color;
}

vec3 gradient_tests()
{
    vec2 uv = provide_uv();
    //uv = provide_uv_interactive();
    vec3 color = vec3(1.0);

    //float line = step(0.45, uv.y) * step(uv.y, 0.55);
    //color = vec3(1.0) * line;

    uv.y = floor(uv.y * 20.0);

    vec3 input_color = color_hex_to_rgb(0xcc9966);
    color = color_gradient_generated_perlin(
            uv.x,
            input_color,
            uv.y,
            5.0,
            5.0,
            4.0, 2.0, 2.0);

    return color;
}


void main() {

    vec3 color = gradient_tests();

	gl_FragColor = vec4(color, 1.0);
}