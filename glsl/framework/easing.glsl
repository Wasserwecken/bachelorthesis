#include "constants.glsl"

#ifndef EASING
#define EASING


//////////////////////////////
// Easing (http://gizma.com/easing/)
//////////////////////////////
float easing_smoother_step(float x)
{
    return x*x*x * (6.0 * x*x - 15.0 * x + 10.0);
}

vec2 easing_smoother_step(vec2 x)
{
    return vec2(
        easing_smoother_step(x.x),
        easing_smoother_step(x.y)
    );
}

vec3 easing_smoother_step(vec3 x)
{
    return vec3(
        easing_smoother_step(x.x),
        easing_smoother_step(x.y),
        easing_smoother_step(x.z)
    );
}


float easing_power_in(float x, float power)
{
    return pow(x, power);
}

vec2 easing_power_in(vec2 x, vec2 power)
{
    return vec2(
        easing_power_in(x.x, power.x),
        easing_power_in(x.y, power.y)
    );
}

vec3 easing_power_in(vec3 x, vec3 power)
{
    return vec3(
        easing_power_in(x.x, power.x),
        easing_power_in(x.y, power.y),
        easing_power_in(x.z, power.z)
    );
}


float easing_power_out(float x, float power)
{
    return 1.0 - pow(1.0 - x, power);
}

vec2 easing_power_out(vec2 x, vec2 power)
{
    return vec2(
        easing_power_out(x.x, power.x),
        easing_power_out(x.y, power.y)
    );
}

vec3 easing_power_out(vec3 x, vec3 power)
{
    return vec3(
        easing_power_out(x.x, power.x),
        easing_power_out(x.y, power.y),
        easing_power_out(x.z, power.z)
    );
}


float easing_power_inout(float x, float power)
{
    x *= 2.0;
    float is_in = step(x, 1.0);
    float ease_in = easing_power_in(x, power);
    float ease_out = easing_power_out(x - 1.0, power);

    return (is_in * ease_in + (1.0 - is_in) * (ease_out + 1.0)) * .5;
}

vec2 easing_power_inout(vec2 x, vec2 power)
{
    return vec2(
        easing_power_inout(x.x, power.x),
        easing_power_inout(x.y, power.y)
    );
}

vec3 easing_power_inout(vec3 x, vec3 power)
{
    return vec3(
        easing_power_inout(x.x, power.x),
        easing_power_inout(x.y, power.y),
        easing_power_inout(x.z, power.z)
    );
}


float easing_circular_in(float x)
{
    x = min(x, 1.0);
    return 1.0 - sqrt(1.0 - x * x);
}

vec2 easing_circular_in(vec2 x)
{
    return vec2(
        easing_circular_in(x.x),
        easing_circular_in(x.y)
    );
}

vec3 easing_circular_in(vec3 x)
{
    return vec3(
        easing_circular_in(x.x),
        easing_circular_in(x.y),
        easing_circular_in(x.z)
    );
}


float easing_circular_out(float x)
{
    x = max(x, 0.0);
    return sqrt(1.0 - --x * x);
}

vec2 easing_circular_out(vec2 x)
{
    return vec2(
        easing_circular_out(x.x),
        easing_circular_out(x.y)
    );
}

vec3 easing_circular_out(vec3 x)
{
    return vec3(
        easing_circular_out(x.x),
        easing_circular_out(x.y),
        easing_circular_out(x.z)
    );
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

vec2 easing_circular_inout(vec2 x)
{
    return vec2(
        easing_circular_inout(x.x),
        easing_circular_inout(x.y)
    );
}

vec3 easing_circular_inout(vec3 x)
{
    return vec3(
        easing_circular_inout(x.x),
        easing_circular_inout(x.y),
        easing_circular_inout(x.z)
    );
}


float easing_sinus_in(float x)
{
    return sin(x * PI05);
}

vec2 easing_sinus_in(vec2 x)
{
    return vec2(
        easing_sinus_in(x.x),
        easing_sinus_in(x.y)
    );
}

vec3 easing_sinus_in(vec3 x)
{
    return vec3(
        easing_sinus_in(x.x),
        easing_sinus_in(x.y),
        easing_sinus_in(x.z)
    );
}


float easing_sinus_out(float x)
{
    return sin(x * PI05 - PI) + 1.0;
}

vec2 easing_sinus_out(vec2 x)
{
    return vec2(
        easing_sinus_out(x.x),
        easing_sinus_out(x.y)
    );
}

vec3 easing_sinus_out(vec3 x)
{
    return vec3(
        easing_sinus_out(x.x),
        easing_sinus_out(x.y),
        easing_sinus_out(x.z)
    );
}


float easing_sinus_inout(float x)
{
    return sin(x * PI - PI05) * 0.5 + 0.5;
}

vec2 easing_sinus_inout(vec2 x)
{
    return vec2(
        easing_sinus_inout(x.x),
        easing_sinus_inout(x.y)
    );
}

vec3 easing_sinus_inout(vec3 x)
{
    return vec3(
        easing_sinus_inout(x.x),
        easing_sinus_inout(x.y),
        easing_sinus_inout(x.z)
    );
}


float easing_zic(float x)
{
    return abs(x - 0.5);
}

float easing_zac(float x)
{
    return 1.0 - abs(x - 0.5);
}


#endif
