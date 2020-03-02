#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"
#include "/textures/processed_wood.glsl"





float pattern(vec2 uv)
{
    return 0.5;
}

float pattern_wool(vec2 uv)
{
    vec2 line_id;
    uv = uv_tilling_01(uv, line_id, vec2(10.0));

    float dir = step(mod(line_id.x, 2.0), .5) * 2.0 - 1.0;
    uv.y = fract(uv.y + (uv.x * dir));

    float line = shape_rectangle(uv, vec2(0.5), vec2(2.0, 0.5), vec2(0.0, 0.5));
    float foo = shape_rectangle(uv, vec2(0.5), vec2(0.9, 1.0), vec2(0.1, 0.0));
    line *= foo;
    
    line = easing_circular_out(line);

    return line;
}

float pattern_web(vec2 uv)
{    
    uv = fract(uv * 10.0);
    
    vec2 size = vec2(2.0, 0.35);
    float horizontal1 = shape_rectangle(uv, vec2(0.5, 0.25), size, vec2(0.0));
    float horizontal2 = shape_rectangle(uv, vec2(0.5, 0.75), size, vec2(0.0));
    float vertical1 = shape_rectangle(uv, vec2(0.25, 0.5), size.yx, vec2(0.0));
    float vertical2 = shape_rectangle(uv, vec2(0.75, 0.5), size.yx, vec2(0.0));

    uv *= PI2;
    horizontal1 *= sin(uv.x) * .25 + .5;
    horizontal2 *= sin(uv.x + PI) * .25 + .5;
    vertical1 *= sin(uv.y + PI) * .25 + .5;
    vertical2 *= sin(uv.y) * .25 + .5;

    float height = horizontal1;
    height = max(height, horizontal2);
    height = max(height, vertical1);
    height = max(height, vertical2);

    return height;
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
    vec2 uv = provide_uv();

    vec3 albedo;
    float metallic;
    float roughness;
    float height;
    vec3 normal;


    height = pattern_wool(uv);

    vec3 color = vec3(0.0);
    color = vec3(metallic);
    color = normal;
    color = albedo;
    color = vec3(roughness);
    color = vec3(height);

	gl_FragColor = vec4(color, 1.0);
}