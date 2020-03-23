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



float noise_voronoi_edge(vec2 point, out vec2 cell_id, vec2 seed)
{
    vec2 x = point * NOISE_SCALE;

    vec2 p = vec2(floor( x ));
    vec2  f = fract( x );

    vec2 mb;
    vec2 mr;

    float res = 8.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 b = vec2(i, j);
        vec2  r = vec2(b) + noise_white_vec2(p+b) - f;
        float d = dot(r,r);

        if( d < res )
        {
            res = d;
            mr = r;
            mb = b;
            cell_id = p + b;
        }
    }

    res = 8.0;
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 b = mb + vec2(i, j);
        vec2  r = vec2(b) + noise_white_vec2(p+b) - f;
        float d = dot(0.5*(mr+r), normalize(r-mr));

        res = min( res, d );
    }

    return res;
}





void main() {

    vec2 uv = provide_uv();
    vec3 color = vec3(1.0);

    vec2 id;
    float noise;
    color *= noise_voronoi_edge(uv, id, vec2(0.0)) * 6.0 - 0.2;


    
	gl_FragColor = vec4(color, 1.0);
}