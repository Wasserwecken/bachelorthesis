#ifndef EASING
#define EASING


//////////////////////////////
// Easing (http://gizma.com/easing/)
//////////////////////////////
float easing_smoother_step(float x)
{
    return x * x * x * (6.0 * x * x - 15.0 * x + 10.0);
}

vec2 easing_smoother_step(vec2 x)
{
    return x * x * x * (6.0 * x * x - 15.0 * x + 10.0);
}

vec3 easing_smoother_step(vec3 x)
{
    return x * x * x * (6.0 * x * x - 15.0 * x + 10.0);
}

float easing_power_in(float x, float power)
{
    return pow(x, power);
}

float easing_power_out(float x, float power)
{
    return 1.0 - pow(1.0 - x, power);
}

float easing_power_inout(float x, float power)
{
    x *= 2.0;

    float is_in = step(x, 1.0);
    float ease_in = easing_power_in(x, power);
    float ease_out = easing_power_out(x - 1.0, power);

    float ease = is_in * ease_in + (1.0 - is_in) * (ease_out + 1.0);

    return ease * .5;
}

float easing_circular_in(float x)
{
    x = min(x, 1.0);
    return 1.0 - sqrt(1.0 - x * x);
}

float easing_circular_out(float x)
{
    x = max(x, 0.0);
    return sqrt(1.0 - --x * x);
}

float easing_circular_inout(float x)
{
    x *= 2.0;

    float is_in = step(x, 1.0);
    float ease_in = easing_circular_in(x);
    float ease_out = easing_circular_out(x - 1.0);

    float ease = is_in * ease_in + (1.0 - is_in) * (ease_out + 1.0);

    return ease * .5;
}


#endif
