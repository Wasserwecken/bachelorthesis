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
    stem_uv = bar_uv + noise_white_vec2(bar_id) * 2.0 - 1.0;
    stem_uv = uv_tilling_01(stem_uv, stem_id, vec2(0.5));

    vec2 stem_seed = stem_id + bar_id;
    float has_stem = step(0.6, noise_white(stem_seed++));
    float stem_radius_variance = value_remap(noise_perlin(stem_uv, stem_seed++, 5.0), 0.0, 1.0, 0.6, 1.0);
    float stem_radius = noise_white(stem_seed++) * 0.2 * stem_radius_variance;
    float stem_blur = 0.2;
    vec2 stem_origin = noise_white_vec2(stem_seed++) * (1.0 - 2.0 * stem_blur) + stem_blur;
    float stem = has_stem * shape_circle(stem_uv, stem_origin, stem_radius, stem_blur);
    stem = easing_power_in(stem, 4.0);


    //ring distorions
    vec2 noise_uv = bar_uv * vec2(1.5, 10.0) * 0.075;
    float ring_noise = noise_perlin_layered(noise_uv, bar_id, 1.0, 4.0, 1.5, 1.5);
    ring_noise = pow(ring_noise, 2.0);
    vec2 ring_uv = uv_distort_twirl(uv, 1.0, ring_noise, .06) * 20.0;
    ring_uv = uv_distort_twirl(ring_uv, 1.0, stem * .5 + .5, 1.0);


    //rings / aging lines
    vec2 primary_uv = ring_uv;
    float primary_id = floor(primary_uv.y) + bar_id.y;
    float primary_gradient = noise_white(primary_id);
    float primary_lines = fract(primary_uv.y);
    float primary = primary_gradient * primary_lines;
    primary = value_remap(primary, 0.0, 1.0, 0.5, 1.0);


    //float secondary_line_count = 2.0 + ceil(noise_white(primary_id) * 3.0);
    float secondary_line_count = 10.0 + ceil(noise_white(primary_id) * 10.0);
    vec2 secondary_uv = primary_uv * secondary_line_count;
    float secondary_id = floor(secondary_uv.y) + bar_id.y;
    float secondary_gradient = noise_white(secondary_id);
    float secondary_lines = fract(secondary_uv.y);
    float secondary = secondary_gradient * secondary_lines;
    secondary = value_remap(secondary, 0.0, 1.0, 0.75, 1.0);

    float rings = primary * secondary;


    //gum
    vec2 gum_id;
    vec2 gum_uv = uv;
    gum_uv = uv_tilling_01(gum_uv, gum_id, vec2(60.0));
    float gum_distortion = noise_perlin(gum_uv, gum_id, 2.0);
    gum_uv = uv_distort_twirl(gum_uv, 1.0, gum_distortion, .1);

    vec2 gum_seed = gum_id + 10.0;
    float has_gum = step(0.97, noise_white(gum_seed++));
    float gum_radius_variance = noise_white(gum_seed++);
    float gum_radius = 0.1 + gum_radius_variance * 0.2;
    float gum_blur = 0.1;
    float gum_wear = easing_power_in(easing_zic(secondary_lines), 2.0);// * noise_white(gum_seed++);
    vec2 gum_origin = noise_white_vec2(gum_seed++) * (1.0 - 2.0 * (gum_radius + gum_blur)) + (gum_radius + gum_blur);
    float gum = has_gum * shape_circle(gum_uv, gum_origin, gum_radius, gum_blur);
    gum = clamp(gum - gum_wear, 0.0, 1.0);
    gum = easing_power_out(gum, 4.0);


    //zigaret burn



    //fibers and pores
    vec2 dot_uv = uv * vec2(2.0, 10.0);
    float dots = noise_perlin_layered(dot_uv, bar_id, 300.0, 2.0, 2.0, 2.0);
    dots = easing_smoother_step(dots);
    dots = value_remap(dots, 0.0, 1.0, 0.7, 1.0);

    //color variance
    vec2 variance_uv = uv * vec2(1.0, 10.0) * 5.0;
    float variance = noise_perlin_layered(variance_uv, bar_id, 2.0, 3.0, 4.0, 4.0);
    variance = easing_smoother_step(variance);
    variance = value_remap(variance, 0.0, 1.0, 0.75, 1.0);
    float wood = rings * dots * variance;




    vec3 base_wood_color = color_hex_to_rgb(0xcc9966);
    vec3 albedo_bar = base_wood_color;
    float color_bar_variance = value_remap(noise_white(bar_id), 0.0, 1.0, 0.95, 1.0);
    albedo_bar = color_gradient_generated_perlin(
            wood,
            albedo_bar,
            noise_white(bar_id++),
            1.1,
            1.0,
            3.0, 4.0, 2.0);
    albedo = albedo_bar * color_bar_variance;

    vec3 albedo_stem = color_deviation(albedo_bar * 0.2, noise_white(stem_seed), 0.2);
    albedo = mix(albedo, albedo_stem, easing_power_in(stem, 4.0) * 0.5);

    vec3 albedo_gum = color_deviation(base_wood_color * 0.3, noise_white(gum_seed), 0.7);
    albedo = mix(albedo, albedo_gum, gum);


    albedo *= bar;


    //albedo = vec3(gum);

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
    vec2 uv = provide_uv_interactive();

    vec3 albedo;
    float metallic;
    float roughness;
    float height;
    vec3 normal;


    texture_old_parquet(uv * .5, albedo, metallic, roughness, height, normal);


    vec3 color = vec3(0.0);
    color = vec3(metallic);
    color = vec3(roughness);
    color = normal;
    color = vec3(height);
    color = albedo;

	gl_FragColor = vec4(color, 1.0);
}