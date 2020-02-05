#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"




void texture_old_parquet(vec2 uv, out vec3 albedo, out float metallic, out float roughness, out float height, out vec3 normal)
{
    vec2 tiles = vec2(1.0, 40.0);

    // UV tilling
    vec2 bar_id;
    vec2 bar_uv = uv_tilling_0X(uv, bar_id, tiles, 1.0, .3);
    vec2 bar_center = tiles.yx / 2.0 + (noise_white_vec2(bar_id) * 2.0 - 1.0) * 0.01;
    vec2 bar_size = tiles.yx - 0.07;
    float bar_blur = noise_perlin_layered(bar_uv, bar_id, 2.0, 2.0, 2.0, 2.0) * 0.075;
    float bar_bend = noise_perlin(uv, bar_id, 4.0);

    // bar shape
    bar_uv = uv_rotate(bar_uv, bar_center, 0.025);
    bar_uv = uv_distort_twirl(bar_uv, 0.1, bar_bend, 0.1); 
    float bar = shape_rectangle(bar_uv, bar_center, bar_size, vec2(bar_blur));
    bar = easing_circular_out(bar);

    //stem
    vec2 stem_uv;
    vec2 stem_id;
    stem_uv = uv_tilling_01(bar_uv, stem_id, vec2(3.0, 1.0), 1.0, 0.0);

    float has_stem = step(0.5, noise_white(stem_id));
    float stem_radius_variance = value_remap(noise_perlin(stem_uv, stem_id, 5.0), 0.0, 1.0, 0.6, 1.0);
    float stem_radius = 0.1 * stem_radius_variance;
    float stem_blur = stem_radius * 2.0;
    vec2 stem_origin = noise_white_vec2(stem_id) * (1.0 - 2.0 * stem_blur) + stem_blur;
    float stem = has_stem * shape_circle(stem_uv, stem_origin, stem_radius, stem_blur);

    //ring distorions
    vec2 noise_uv = bar_uv * vec2(1.5, 10.0) * 0.075;
    float ring_noise = noise_perlin_layered(noise_uv, bar_id, 1.0, 4.0, 1.5, 1.5);
    ring_noise = pow(ring_noise, 2.0);
    vec2 ring_uv = uv_distort_twirl(uv, 1.0, ring_noise, .06) * 20.0;
    ring_uv = uv_distort_twirl(ring_uv, 1.0, stem * .5 + .5, 1.3);

    //rings / aging lines
    vec2 primary_uv = ring_uv;
    float primary_id = floor(primary_uv.y) + bar_id.y;
    float primary_gradient = noise_white(primary_id);
    float primary_lines = fract(primary_uv.y);
    float primary = primary_gradient * primary_lines;
    primary = value_remap(primary, 0.0, 1.0, 0.5, 1.0);

    float secondary_line_count = 2.0 + ceil(noise_white(primary_id) * 3.0);
    vec2 secondary_uv = primary_uv * secondary_line_count;
    float secondary_id = floor(secondary_uv.y) + bar_id.y;
    float secondary_gradient = noise_white(secondary_id);
    float secondary_lines = fract(secondary_uv.y);
    float secondary = secondary_gradient * secondary_lines;
    secondary = value_remap(secondary, 0.0, 1.0, 0.75, 1.0);
    float rings = primary * secondary;

    //fibers and pores
    vec2 dot_uv = uv * vec2(2.0, 10.0);
    float dots = noise_perlin_layered(dot_uv, bar_id, 75.0, 2.0, 2.0, 2.0);
    dots = easing_smoother_step(dots);
    dots = value_remap(dots, 0.0, 1.0, 0.7, 1.0);

    //color variance
    vec2 variance_uv = uv * vec2(1.0, 10.0) * 5.0;
    float variance = noise_perlin_layered(variance_uv, bar_id, 2.0, 3.0, 4.0, 4.0);
    variance = easing_smoother_step(variance);
    variance = value_remap(variance, 0.0, 1.0, 0.75, 1.0);
    float wood = rings * dots * variance;




    albedo = color_hex_to_rgb(0xcc9966);
    albedo = color_gradient_generated_perlin(
            wood,
            albedo,
            0.0,
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