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
    uv = uv * 2.0 - 1.0;
    
    vec2 mouse = iMouse.xy / iResolution.y;
    uv *= mouse.y;

    return uv;
}


void main() {
    vec2 uv = provide_uv();

    uv *= vec2(2.0, 20.0);
    vec2 id = floor(uv);
    uv = fract(uv);
    vec3 color = vec3(uv, 0.0);
    color = vec3(noise_perlin_vec1_layered(uv.x, 0.0, 5.0, 3.0, 4.0, 4.0));
    color = random_color_gradient(uv.x + iTime * 0.0, id);
    color = random_color_gradient_2(uv.x + iTime * 0.0, id, 2.0);

	gl_FragColor = vec4(color, 1.0);
}