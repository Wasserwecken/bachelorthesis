#include "constants.glsl"
#include "easing.glsl"
#include "noise.glsl"

#ifndef COLOR
#define COLOR

//////////////////////////////
// Colors
//////////////////////////////

// https://stackoverflow.com/questions/22895237/hexadecimal-to-rgb-values-in-webgl-shader
vec3 color_hex_to_rgb(int hex_code)
{
    return vec3(
        mod(float(hex_code / 256 / 256), 256.0),
        mod(float(hex_code / 256), 256.0),
        mod(float(hex_code), 256.0)
    ) / 255.0;
}


//https://stackoverflow.com/questions/15095909/from-rgb-to-hsv-in-opengl-glsl
vec3 color_rgb_to_hsv(vec3 rgb)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(rgb.bg, K.wz), vec4(rgb.gb, K.xy), step(rgb.b, rgb.g));
    vec4 q = mix(vec4(p.xyw, rgb.r), vec4(rgb.r, p.yzx), step(p.x, rgb.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

//https://stackoverflow.com/questions/15095909/from-rgb-to-hsv-in-opengl-glsl
vec3 color_hsv_to_rgb(vec3 hsl)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(hsl.xxx + K.xyz) * 6.0 - K.www);
    return hsl.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), hsl.y);
}


//https://www.iquilezles.org/www/articles/palettes/palettes.htm
vec3 color_gradient_generated_cos(float t, float s, vec3 a, vec3 b, vec3 c, vec3 d)
{
    return a + b * cos(PI2 * (c + d * s * t));
}


vec3 color_gradient_generated_perlin(
        float t,
        vec3 color,
        float seed,
        float scale,
        float dist,
        float layers,
        float layers_scale,
        float layers_weight)
{
    vec3 interpolation = vec3(
        noise_perlin_layered(t, noise_white(seed), scale, layers, layers_scale, layers_weight),
        noise_perlin_layered(t, noise_white(seed), scale, layers, layers_scale, layers_weight),
        noise_perlin_layered(t, noise_white(seed), scale, layers, layers_scale, layers_weight)
    );
    interpolation = easing_power_inout(interpolation, vec3(dist)) * 2.0 - 1.0;
    return (color * interpolation) + color;
}

vec3 color_gradient_generated_perlin(
        float t,
        vec3 color,
        vec3 seed,
        vec3 scale,
        vec3 dist,
        vec3 layers,
        vec3 layers_scale,
        vec3 layers_weight)
{
    vec3 interpolation = vec3(
        noise_perlin_layered(t, noise_white(seed.x), scale.x, layers.x, layers_scale.x, layers_weight.x),
        noise_perlin_layered(t, noise_white(seed.y), scale.y, layers.y, layers_scale.y, layers_weight.y),
        noise_perlin_layered(t, noise_white(seed.z), scale.z, layers.z, layers_scale.z, layers_weight.z)
    );
    interpolation = easing_power_inout(interpolation, dist) * 2.0 - 1.0;
    return (color * interpolation) + color;
}


#endif
