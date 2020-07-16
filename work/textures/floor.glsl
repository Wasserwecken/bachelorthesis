#include "work/glslLib/lib/constants.glsl"
#include "work/glslLib/lib/helper.glsl"
#include "work/glslLib/lib/easing.glsl"
#include "work/glslLib/lib/shapes.glsl"
#include "work/glslLib/lib/noise.glsl"
#include "work/glslLib/lib/uv.glsl"
#include "work/glslLib/lib/color.glsl"



vec3 v1(vec2 uv, vec2 seed)
{
    uv = uv_rotate(uv, vec2(0.5), 90.0);

    vec2 plank_id;
    vec2 plank_uv;
    vec2 plank_scale = vec2(20.0, 1.0);
    plank_uv = uv_tilling(uv, plank_id, plank_scale.yx);

    float offset;
    offset = random(plank_id.y);
    plank_uv = uv_tilling_offset(plank_uv, plank_id, offset, 1.0);
    plank_uv *= plank_scale;
    //return vec3(plank_uv, 0.0);

    float plank_shape;
    plank_shape = shape_box(plank_uv, vec2(0.5) * plank_scale, plank_scale * 0.5 - 0.05, vec2(0.07));
    return vec3(plank_shape);
}

vec3 v2(vec2 uv, vec2 seed)
{
    uv = uv_rotate(uv, vec2(0.5), 90.0);

    vec2 plank_id;
    vec2 plank_uv;
    vec2 plank_seed;
    vec2 plank_scale = vec2(20.0, 1.0);
    plank_uv = uv_tilling(uv, plank_id, plank_scale.yx);
    plank_seed = plank_id;

    float offset;
    offset = random(plank_id.y);
    plank_uv = uv_tilling_offset(plank_uv, plank_id, offset, 1.0);
    plank_uv *= plank_scale;

    float distortion;
    distortion = noise_perlin(plank_uv * 0.01, plank_seed++);
    plank_uv = uv_distort_twirl(plank_uv, distortion, vec2(0.12), 1.0);

    float plank_shape;
    plank_shape = shape_box(plank_uv, vec2(0.5) * plank_scale, plank_scale * 0.5 - 0.05, vec2(0.07));
    plank_shape = easing_power_out(plank_shape, 3.0);

    float tilt;
    tilt = noise_perlin(plank_uv * 0.01, plank_seed++);
    tilt = easing_power_inout(tilt, 3.0);
    plank_shape -= tilt * 0.3;

    return vec3(plank_shape);
}

vec3 v3(vec2 uv, vec2 seed)
{

    vec2 branch_id;
    vec2 branch_uv = uv_tilling(uv, branch_id, vec2(5.0));

    vec2 branch_seed = seed + branch_id;
    float branch_size = easing_power_out(random(branch_seed++) * 0.2, 1.5);
    float branch_blur = 0.3;
    float branch_buffer = branch_size + branch_blur;
    vec2 branch_position = value_remap(random_vec2(branch_seed++), 0.0, 1.0, branch_buffer, 1.0 - branch_buffer);
    float branch_distortion = shape_circle(branch_uv, branch_position, branch_size, branch_blur);
    branch_distortion = easing_power_in(branch_distortion, 3.0);
    branch_distortion *= step(mod(branch_id.y + branch_id.x, 2.0), 0.5);
    float branch_area = step(0.8, branch_distortion);
    //return vec3(branch_distortion);

    vec2 ring_uv = uv;
    ring_uv = uv_rotate(ring_uv, branch_position, branch_distortion * 20.0);
    ring_uv *= vec2(1.1, 0.1);

    float ring_base = noise_perlin(ring_uv, seed);
    float rings = easing_power_out(ring_base, 3.0);
    rings = fract(rings * 5.0);
    float rings2 = fract(rings * 5.0);
    float rings3 = fract(rings2 * 5.0);
    rings = rings * 0.5 + rings2 * 0.25 + rings3 * 0.125;
    //return vec3(rings);


    rings += branch_area * 0.33;

    return vec3(rings);
}

void wood(vec2 uv, vec2 seed, out vec3 albedo, out float height)
{
    vec2 branch_id;
    uv += random_vec2(seed);
    vec2 branch_uv = uv_tilling(uv, branch_id, vec2(5.0));
    vec2 branch_seed = random_vec2(seed + branch_id);
    float branch_size = easing_power_out(random(branch_seed++) * 0.2, 1.5);
    float branch_blur = 0.3;
    float branch_buffer = branch_size + branch_blur;
    vec2 branch_position = value_remap(random_vec2(branch_seed++), 0.0, 1.0, branch_buffer, 1.0 - branch_buffer);
    float branch_distortion = shape_circle(branch_uv, branch_position, branch_size, branch_blur);
    branch_distortion = easing_power_in(branch_distortion, 3.0);
    branch_distortion *= step(random(branch_seed++), 0.5);
    float branch_area = step(0.8, branch_distortion);

    vec2 ring_uv = uv;
    ring_uv = uv_rotate(ring_uv, branch_position, branch_distortion * 20.0);
    ring_uv *= vec2(1.1, 0.1);

    vec2 ring_seed = random_vec2(seed);
    float ring_base = noise_perlin(ring_uv, ring_seed);
    float rings = easing_power_out(ring_base, 3.0);
    rings = fract(rings * 5.0);
    float rings2 = fract(rings * 5.0);
    float rings3 = fract(rings2 * 5.0);
    rings = rings * 0.5 + rings2 * 0.25 + rings3 * 0.125;

    height = rings + branch_area * 0.7;
    albedo = vec3(height);
}

vec3 v4(vec2 uv, vec2 seed)
{
    vec2 plank_id;
    vec2 plank_seed;
    vec2 plank_scale = vec2(20.0, 1.0);
    vec2 plank_uv = uv_rotate(uv, vec2(0.5), 90.0);
    plank_uv = uv_tilling(plank_uv, plank_id, plank_scale.yx);

    float offset;
    offset = random(plank_id.y);
    plank_uv = uv_tilling_offset(plank_uv, plank_id, offset, 1.0);
    plank_uv *= plank_scale;
    plank_seed = seed + plank_id;

    float distortion;
    distortion = noise_perlin(plank_uv * 0.01, plank_seed++);
    plank_uv = uv_distort_twirl(plank_uv, distortion, vec2(0.12), 1.0);

    float plank_shape;
    plank_shape = shape_box(plank_uv, vec2(0.5) * plank_scale, plank_scale * 0.5 - 0.05, vec2(0.07));
    plank_shape = easing_power_out(plank_shape, 3.0);

    float tilt;
    tilt = noise_perlin(plank_uv * 0.01, plank_seed++);
    tilt = easing_power_inout(tilt, 3.0);
    plank_shape -= tilt * 0.3;


    float wood_height;
    vec3 wood_albedo;
    vec2 wood_uv = uv_rotate(plank_uv, vec2(0.5), -90.0);
    wood(wood_uv * 0.1, plank_seed++, wood_albedo, wood_height);
    plank_shape -= wood_height * 0.2;


    return vec3(plank_shape);
}


void main() {
    vec2 uv = uv_provide();
    vec2 seed = vec2(33.33);

    vec3 result;
    //result = v1(uv, seed);
    //result = v2(uv, seed);
    //result = v3(uv, seed);
    result = v4(uv, seed);

	gl_FragColor = vec4(result, 1.0);
}