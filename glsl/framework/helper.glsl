#ifndef HELPER
#define HELPER

//////////////////////////////
// Value manipulations
//////////////////////////////
float value_manhatten_length(vec2 vector)
{
    vector = abs(vector);
    return vector.x + vector.y;
}

float value_remap(float value, float in_lower, float in_upper, float out_lower, float out_upper)
{
    value -= in_lower;
    value *= out_upper - out_lower;
    value /= in_upper - in_lower;
    value += out_lower;

    return value;
}

vec2 value_remap(vec2 value, vec2 in_lower, vec2 in_upper, vec2 out_lower, vec2 out_upper)
{
    return vec2(
        value_remap(value.x, in_lower.x, in_upper.x, out_lower.x, out_upper.x),
        value_remap(value.y, in_lower.y, in_upper.y, out_lower.y, out_upper.y)

    );
}

vec3 value_remap(vec3 value, vec3 in_lower, vec3 in_upper, vec3 out_lower, vec3 out_upper)
{
    return vec3(
        value_remap(value.x, in_lower.x, in_upper.x, out_lower.x, out_upper.x),
        value_remap(value.y, in_lower.y, in_upper.y, out_lower.y, out_upper.y),
        value_remap(value.z, in_lower.z, in_upper.z, out_lower.z, out_upper.z)

    );
}


float value_linear_step(float value, float edge, float edge_width)
{
    float f = (value - edge + (edge_width * .5)) / edge_width;
    return clamp(f, 0.0, 1.0);
}

vec2 value_linear_step(vec2 value, vec2 edge, vec2 edge_width)
{
    return vec2(
        value_linear_step(value.x, edge.x, edge_width.x),
        value_linear_step(value.y, edge.y, edge_width.y)
    );
}

float value_posterize(float value, float steps)
{
    return floor(value * steps) / steps;
}

vec2 value_posterize(vec2 value, vec2 steps)
{
    return vec2(
        value_posterize(value.x, steps.x),
        value_posterize(value.y, steps.y)
    );
}

vec3 value_posterize(vec3 value, vec3 steps)
{
    return vec3(
        value_posterize(value.x, steps.x),
        value_posterize(value.y, steps.y),
        value_posterize(value.z, steps.z)
    );
}



//////////////////////////////
// Converters
//////////////////////////////
vec3 converter_height_to_normal(float height, float strength)
{
    float x = -dFdx(height);
    float y = -dFdy(height);
    float depth = 1.0 / strength;

    vec3 normal = vec3(x, y, depth);
    normal = normalize(normal);
    normal = normal * 0.5 + 0.5;

    return normal;
}

#endif