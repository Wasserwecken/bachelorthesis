#include "constants.glsl"
#include "easing.glsl"
#include "noise.glsl"

#ifndef COLOR
#define COLOR

//////////////////////////////
// Colors
//////////////////////////////
vec3 random_color_gradient(float x, vec2 seed)
{
    vec3 a = noise_white_vec3(noise_white_vec2(seed++));
    vec3 b = noise_white_vec3(noise_white_vec2(seed++)) * (1.0 - a);
    vec3 c = noise_white_vec3(noise_white_vec2(seed++));
    vec3 d = noise_white_vec3(noise_white_vec2(seed++));

    return a + b * cos(4.0 * PI2 * (c * x + d));
}

vec3 random_color_gradient_2(float x, vec2 seed, float scale)
{
    float l = 3.0;
    float s = 2.0;
    float w = 2.0;

    vec3 interpol = vec3(
        noise_perlin_vec1_layered(x, noise_white(seed++), scale, l, s, w),
        noise_perlin_vec1_layered(x, noise_white(seed++), scale, l, s, w),
        noise_perlin_vec1_layered(x, noise_white(seed++), scale, l, s, w)
    );
    interpol = easing_smoother_step(interpol);
    interpol = easing_smoother_step(interpol);
    interpol = easing_smoother_step(interpol);
    interpol = easing_smoother_step(interpol);

    vec3 a = noise_white_vec3(seed++);
    vec3 b = noise_white_vec3(seed);

    //return vec3(interpol.x);
    return mix(a, b, interpol);
}


#endif
