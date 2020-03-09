vec2 provide_uv()
{
    vec2 uv = gl_FragCoord.xy / iResolution.y;

    return uv;
}


vec3 pattern1(vec2 uv)
{
    vec3 result = vec3(0.0);


    // full color
    float line = floor(uv.x * 9.0);
    float red = mod(line, 2.0);
    float green = mod(line * 0.5, 2.0);
    float blue = mod(line * 0.25, 2.0);

    result = vec3(red, green, blue);
    result = step(1.0, result);


    // color dark
    float area = uv.y * 3.0;
    float area_id = floor(area);

    float is_low_key = step(area, 1.0);
    float is_heigh_key = step(2.0, area);

    area = fract(area);
    result = is_low_key * (result * area)
            + (1.0 - is_low_key) * result;

    result = is_heigh_key * (mix(result, vec3(1.0), area))
            + (1.0 - is_heigh_key) * result;


    //contrast steped
    line = floor(uv.y * 12.0);
    float steps = 20.0;
    float is_contrast_smooth = step(7.0, line) * step(line, 7.0);
    float is_contrast_stepped = step(4.0, line) * step(line, 4.0);

    result = is_contrast_smooth * (vec3(1.0 - uv.x))
            + (1.0 - is_contrast_smooth) * result;
    result = is_contrast_stepped * (vec3(floor(uv.x * steps) / (steps - 1.0)))
            + (1.0 - is_contrast_stepped) * result;

    return result;
}


void main() {
    vec2 uv = provide_uv();

    vec3 color = vec3(0.0);
    color = pattern1(uv);

	gl_FragColor = vec4(color, 1.0);
}