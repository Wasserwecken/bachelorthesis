#include "work/glslLib/lib/constants.glsl"
#include "work/glslLib/lib/helper.glsl"
#include "work/glslLib/lib/easing.glsl"
#include "work/glslLib/lib/shapes.glsl"
#include "work/glslLib/lib/noise.glsl"
#include "work/glslLib/lib/uv.glsl"
#include "work/glslLib/lib/color.glsl"



float v(
        vec3 point,
        vec3 seed,
        out vec3 cell_id,
        out vec3 cell_center,
        out float distance_center,
        vec3 strength)
{
    float n = noise_voronoi_edge(point, seed, cell_id, cell_center, distance_center, strength);
    //float flip = step(mod(cell_id.x + cell_id.y, 2.0), 0.1) * 2.0 - 1.0;
    float flip = step(random(cell_id), 0.5) * 2.0 - 1.0;

    n = clamp(n, 0.0, 1.0) * flip;
    n *= 2.0;

    return n * 0.5 + 0.5;
}

vec3 v1(vec2 uv, vec2 seed)
{
    
    vec3 id, center;
    float d;

    vec2 block_uv = uv + 0.01 * (noise_value_vec2(uv * 2.0, seed++, 2.0, 3, 0.5, 2.0) * 2.0 - 1.0);
    float height = v(vec3(block_uv, 0.0), vec3(seed++, 0.22), id, center, d, vec3(1.0));
    //height += v(vec3(block_uv * 2.0, 0.0), vec3(seed++, 0.22), id, center, d, vec3(1.0)) * 0.5;
    //height /= 1.5;

    return vec3(height);
    

    vec2 crack_uv = block_uv * 0.5;
    float cracks = noise_perlin(crack_uv, seed++, 2, 0.5, 2.0);
    cracks = 1.0 - abs(cracks * 2.0 - 1.0);
    cracks = easing_power_in(cracks, 4.0);
    cracks = value_linear_step(cracks, 0.9, 0.25);
    float crack_mask = noise_value(crack_uv * 2.0, seed++, 2.0) * 2.0 - 1.0;
    cracks *= crack_mask;
    cracks = clamp(cracks, 0.0, 1.0);
    
    height -= cracks;

    float rs = noise_perlin(uv * 1.0, seed++, 5, 0.5 ,2.0);
    height = mix(height, rs, 0.3);
    //return vec3(height);


    height = easing_power_inout(height, 3.0);
    vec3 colorA = mix(color_hex(0x8B9096), color_hex(0xC4C4BC), height);
    rs = easing_power_inout(rs, 5.0);
    vec3 colorB = mix(color_hex(0x6D6865), color_hex(0xC4CFD5), rs);

    float color_d = noise_value(uv * 5.0, seed++, 1., 4, 0.5, 2.0);
    color_d = easing_power_inout(color_d, 2.0);
    vec3 color = mix(colorA, colorB, color_d);
    color = color * (0.5 + 0.5 * noise_value(uv * 5.0, seed++, 1., 4, 0.5, 2.0));
    color *= 0.5 + 0.5 * height;


    float roughness = 1.0 - (height * 0.5);

    return vec3(roughness);
}


void main() {
    vec2 uv = uv_provide();
    vec2 seed = vec2(33.33);

    vec3 result;
    result = v1(uv, seed);
    //result = v2(uv, seed);
    //result = v3(uv, seed);
    //result = v4(uv, seed);
    //result = v5(uv, seed);
    //result = v6(uv, seed);

	gl_FragColor = vec4(result, 1.0);
}