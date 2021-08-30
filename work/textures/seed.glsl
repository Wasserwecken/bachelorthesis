#include "work/glslLib/lib/constants.glsl"
#include "work/glslLib/lib/helper.glsl"
#include "work/glslLib/lib/easing.glsl"
#include "work/glslLib/lib/shapes.glsl"
#include "work/glslLib/lib/noise.glsl"
#include "work/glslLib/lib/uv.glsl"
#include "work/glslLib/lib/color.glsl"


void main() {
    vec2 uv = uv_provide();
    vec2 seed = vec2(33.33);





    // Einteilung der UV in einzelne Bereiche
    
    vec2 wood_uv = uv; // * vec2(1.0, 20.0);

    float noise = noise_perlin(wood_uv, seed);

    float noise1 = fract(noise * 2.0);
    float noise2 = fract(noise * 4.0) * 0.5;
    float noise3 = fract(noise * 8.0) * 0.25;


    noise = noise1 + noise2 + noise3;



    // Zeugs zum anzeigen
    vec3 result;
    result = vec3(wood_uv, 0.0);
    result = vec3(noise);

	gl_FragColor = vec4(result, 1.0);
}