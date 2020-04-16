#include "../framework/noise.glsl"
#include "../framework/noise.fbm.glsl"
#include "../framework/noise.dimensions.glsl"


#ifndef NOISE_TESTS
#define NOISE_TESTS

vec3 noise_voronoi_tests(vec2 uv, float time)
{
    vec3 noise, point, seed, id, center, strength;
    int depth;
    float gain, scale;

    point = vec3(uv, time * 0.02);
    seed = vec3(floor(1.0 + iTime * 0.));
    strength = vec3(sin(iTime * 0.5) * .5 + .5);

    depth = 3;
    gain = 0.5;
    scale = 2.0;


    //noise.x = noise_voronoi(point.x, seed.x, id.x, center.x, strength.x);
    //noise.x = noise_voronoi(point.xy, seed.xy, id.xy, center.xy, strength.xy);
    //noise.x = noise_voronoi(point.xyz, seed.xyz, id.xyz, center.xyz, strength.xyz);
    
    //noise.x = noise_voronoi(point.x, seed.x, id.x, center.x, strength.x, depth, gain, scale);
    //noise.x = noise_voronoi(point.xy, seed.xy, id.xy, center.xy, strength.xy, depth, gain, scale);
    //noise.x = noise_voronoi(point.xyz, seed.xyz, id.xyz, center.xyz, strength.xyz, depth, gain, scale);


    return noise;
}

#endif
