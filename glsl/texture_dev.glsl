#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"




float texture_processed_wood(vec2 uv, vec2 seed)
{
    //ring distorions
    vec2 noise_uv = uv * vec2(1.5, 10.0);
    float ring_noise = noise_perlin_layered(noise_uv, seed, 1.0, 4.0, 1.5, 1.5);
    ring_noise = pow(ring_noise, 2.0);
    vec2 ring_uv = uv_distort_twirl(uv, 1.0, ring_noise, .06) * 20.0;

    //rings / aging lines
    vec2 primary_uv = ring_uv;
    float primary_id = floor(primary_uv.y) + seed.y;
    float primary_gradient = noise_white(primary_id);
    float primary_lines = fract(primary_uv.y);
    float primary = primary_gradient * primary_lines;
    primary = value_remap(primary, 0.0, 1.0, 0.5, 1.0);

    float secondary_line_count = 2.0 + ceil(noise_white(primary_id) * 3.0);
    vec2 secondary_uv = primary_uv * secondary_line_count;
    float secondary_id = floor(secondary_uv.y) + seed.y;
    float secondary_gradient = noise_white(secondary_id);
    float secondary_lines = fract(secondary_uv.y);
    float secondary = secondary_gradient * secondary_lines;
    secondary = value_remap(secondary, 0.0, 1.0, 0.75, 1.0);
    float rings = primary * secondary;

    //fibers
    vec2 dot_uv = uv * vec2(2.0, 10.0);
    float dots = noise_perlin_layered(dot_uv, seed, 75.0, 2.0, 2.0, 2.0);
    dots = easing_smoother_step(dots);
    dots = value_remap(dots, 0.0, 1.0, 0.7, 1.0);

    //color variance
    vec2 variance_uv = uv * vec2(1.0, 10.0) * 5.0;
    float variance = noise_perlin_layered(variance_uv, seed, 2.0, 3.0, 4.0, 4.0);
    variance = easing_smoother_step(variance);
    variance = value_remap(variance, 0.0, 1.0, 0.75, 1.0);

    return rings * dots * variance;
}



void texture_old_parquet(vec2 uv, out vec3 albedo, out float metallic, out float roughness, out float height, out vec3 normal)
{
    vec2 tiles = vec2(1.0, 40.0);

    vec2 bar_id;
    vec2 bar_uv = uv_tilling_0X(uv, bar_id, tiles, 1.0, .3);
    vec2 bar_center = tiles.yx / 2.0 + (noise_white_vec2(bar_id) * 2.0 - 1.0) * 0.01;
    vec2 bar_size = tiles.yx - 0.07;
    float bar_blur = noise_perlin_layered(bar_uv, bar_id, 2.0, 2.0, 2.0, 2.0) * 0.075;
    float bar_bend = noise_perlin(uv, bar_id, 4.0);

    bar_uv = uv_rotate(bar_uv, bar_center, 0.025);
    bar_uv = uv_distort_twirl(bar_uv, 0.1, bar_bend, 0.1); 

    float bar = shape_rectangle(bar_uv, bar_center, bar_size, vec2(bar_blur));
    bar = easing_circular_out(bar);




    float wood = texture_processed_wood(bar_uv * 0.075, bar_id);


    albedo = color_hex_to_rgb(0xcc9966);
    albedo = color_hex_to_rgb(0x7C5D37);
    albedo = color_gradient_generated_perlin(
            wood,
            albedo,
            vec3(0.0),
            1.0,
            2.0,
            3.0, 4.0, 2.0);
    albedo *= bar;

    height = bar * wood;
    normal = converter_height_to_normal(bar * wood, 1.0);
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


    texture_old_parquet(uv * .5, albedo, metallic, roughness, height, normal);


    vec3 color = vec3(0.0);
    color = vec3(metallic);
    color = vec3(roughness);
    color = albedo;
    color = normal;
    color = vec3(height);

	gl_FragColor = vec4(color, 1.0);
}