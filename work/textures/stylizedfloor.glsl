#include "work/glslLib/lib/constants.glsl"
#include "work/glslLib/lib/helper.glsl"
#include "work/glslLib/lib/easing.glsl"
#include "work/glslLib/lib/shapes.glsl"
#include "work/glslLib/lib/noise.glsl"
#include "work/glslLib/lib/uv.glsl"
#include "work/glslLib/lib/color.glsl"



vec3 v1(vec2 uv, vec2 seed)
{
    vec2 id, center;
    float d;

    uv += (noise_perlin_vec2(uv * 2.0, seed++) * 2.0 - 1.0) * 0.0075;

    float floor_tiles = noise_voronoi_edge(uv, seed++, id, center, d, vec2(0.6));
    vec2 tile_id = id;
    float gap = 0.04;
    floor_tiles = value_linear_step(floor_tiles, gap, gap * 2.0);
    floor_tiles = easing_power_inout(floor_tiles, 2.0);


    float height = noise_perlin(uv, id + seed++);
    height = easing_power_inout(height, 2.0);

    
    vec2 ele_seed = tile_id + seed++;
    float ele = noise_perlin(uv * 0.5, ele_seed++);
    ele = easing_power_inout(ele, 2.0);
    ele = value_linear_step(ele, 0.5, 0.0125);

    vec2 crack_seed = tile_id + seed++;
    float cracks = noise_voronoi_edge(uv, crack_seed++, tile_id, center, d, vec2(1.0));
    float crack_distribution = noise_perlin(uv, crack_seed++);
    crack_distribution = easing_power_inout(crack_distribution, 3.0);
    crack_distribution -= 0.6;
    crack_distribution = crack_distribution * 0.2;
    crack_distribution = clamp(crack_distribution, 0.0, 1.0);
    cracks = 1.0 - value_linear_step(cracks, crack_distribution, crack_distribution * 2.0);

    floor_tiles -= cracks * 0.3;


    float color_dist = noise_perlin(uv * 2.0, tile_id + seed++, 3, 0.5, 2.0);
    color_dist = easing_power_inout(color_dist, 5.0);
    vec3 color = mix(color_hex(0xffd663), color_hex(0xb8a570), color_dist);
    color *= value_remap(floor_tiles, 0.0, 1.0, 0.25, 1.0); 


    float roughness = floor_tiles;
    roughness -= color_dist * 0.5;
    roughness *= 0.5;
    roughness = 1.0 - roughness;



    floor_tiles -= ele * 0.025;
    floor_tiles -= height;

    return vec3(color);
}

vec3 v2(vec2 uv, vec2 seed)
{
    return vec3(shape_circle(uv, vec2(0.5), 0.5, 0.0));
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