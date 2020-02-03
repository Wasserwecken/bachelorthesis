#include "constants.glsl"
#include "helper.glsl"

#ifndef SHAPES
#define SHAPES


//////////////////////////////
// Shapes
//////////////////////////////
float shape_circle(vec2 uv, vec2 origin, float radius, float blur)
{
    float len = length(uv - origin);
    return 1.0 - value_linear_step(len, radius, blur);
}

float shape_rectangle(vec2 uv, vec2 origin, vec2 size, vec2 blur)
{
    size *= 0.5;
    uv = abs(uv - origin);
    
    vec2 isRectangle = value_linear_step(size, uv, blur);
    return min(isRectangle.x, isRectangle.y);
}

float shape_spiral(vec2 uv, vec2 origin, float start)
{
    uv -= origin;

    float spiral = (atan(uv.x, uv.y) + PI) / PI2;
    spiral = fract(spiral + 0.5 - start);

    return spiral;  
}

float shape_ngon(vec2 uv, vec2 origin, float radius, float edges, float bend, float blur)
{
    float dist = length(uv - origin);
    float spiral = shape_spiral(uv, origin, 0.0); 

    bend = (bend + 1.0) * 0.5 * PI2;
    spiral = fract(spiral * edges) * 2.0 - 1.0;
    dist *= cos(spiral * (bend / edges));

    return 1.0 - value_linear_step(dist, radius, blur);
}

#endif
