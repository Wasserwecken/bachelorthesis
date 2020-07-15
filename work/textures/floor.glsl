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
    uv *= vec2(1.1, 0.1);


    float ring_base = noise_perlin(uv, seed);
    
    float rings = easing_power_out(ring_base, 3.0);
    rings = fract(rings * 5.0);
    float rings2 = fract(rings * 5.0);
    float rings3 = fract(rings2 * 5.0);
    rings = rings * 0.5 + rings2 * 0.25 + rings3 * 0.125;
    return vec3(rings);



    return vec3(rings);
}


void main() {
    vec2 uv = uv_provide();
    vec2 seed = vec2(33.33);

    vec3 result;
    //result = v1(uv, seed);
    //result = v2(uv, seed);
    result = v3(uv, seed);

	gl_FragColor = vec4(result, 1.0);
}