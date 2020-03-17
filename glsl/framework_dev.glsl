#include "/framework/constants.glsl"
#include "/framework/helper.glsl"
#include "/framework/easing.glsl"
#include "/framework/shapes.glsl"
#include "/framework/noise.glsl"
#include "/framework/uv.glsl"
#include "/framework/color.glsl"

#include "/textures/colortestpattern.glsl"


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

float noise_creases(float noise)
{
    noise = abs(noise * 2.0 -1.0);
    noise = 1.0 - noise;
    noise *= noise * noise * noise * noise * noise;

    return noise;
}







float noise_voronoi_edge(vec2 point, vec2 seed)
{
    point *= NOISE_SCALE;

    vec2 tile_id = floor(point);
    vec2 tile_pos = fract(point);

    vec2 neighbour;
    vec2 center;
    float dist = 10.0;

    for(float x = -1.0; x < 2.0; x++)
    {
        for(float y = -1.0; y < 2.0; y++)
        {
            neighbour = vec2(x, y);
            center = noise_white_vec2(tile_id + seed + neighbour);
            dist = min(dist, value_manhatten_length(center - tile_pos + neighbour));
        }
    }

    return dist * 0.5;
}






void main() {

    vec2 uv = provide_uv_interactive();
    vec3 color = vec3(1.0);


    float foo = noise_voronoi_edge(uv * 2.0, vec2(0.0));


    color *= foo;

	gl_FragColor = vec4(color, 1.0);
}