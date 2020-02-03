#include "constants.glsl"
#include "shapes.glsl"

#ifndef UV
#define UV

//////////////////////////////
// UV
//////////////////////////////
vec2 uv_translate(vec2 uv, vec2 diff)
{
    return uv + diff;
}

vec2 uv_scale(vec2 uv, vec2 scale)
{
    return uv * scale;
}

vec2 uv_rotate(vec2 uv, vec2 origin, float angle)
{
    angle *= DEGTORAD;
    float s = sin(angle);
	float c = cos(angle);
	mat2 m = mat2(c, -s, s, c);

    uv -= origin;
    uv = m * uv;
    uv += origin;

	return uv;
}

vec2 uv_to_polar(vec2 uv, vec2 origin)
{
    float len = length(uv - origin);
    float angle = shape_spiral(uv, origin, 0.0);

    return vec2(angle, len);
}

vec2 uv_tilling_01(vec2 uv, out vec2 tile_id, vec2 tiles, float offset_step, float offset)
{
    uv *= tiles;
    tile_id = floor(uv);
    uv.x -= offset * floor(tile_id.y * (1.0 / offset_step));
    tile_id = floor(uv);
    
    return fract(uv);
}

vec2 uv_tilling_0X(vec2 uv, out vec2 tile_id, vec2 tiles, float offset_step, float offset)
{
    uv *= tiles;
    tile_id = floor(uv);
    uv.x -= offset * floor(tile_id.y * (1.0 / offset_step));
    tile_id = floor(uv);
    
    return fract(uv) * tiles.yx;
}

vec2 uv_distort_warp(vec2 uv, float distortion, float strength)
{
    float x = dFdx(distortion);
    float y = dFdy(distortion);
    vec2 direction = vec2(x,y) * 10.0;

    return uv + direction * distortion * strength;
}

vec2 uv_distort_twirl(vec2 uv, float offset, float distortion, float strength)
{
    distortion = ((distortion * 360.0) - 180.0) * strength;
    return uv_rotate(uv, uv + vec2(offset), distortion);
}



#endif
