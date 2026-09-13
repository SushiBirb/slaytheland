#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float time;
    float intensity;
    float vignette;
    vec2 resolution;
};

layout(binding = 1) uniform sampler2D source;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void main() {
    vec2 uv = qt_TexCoord0;

    // 12 fps stepped animation frame sampling
    float frame = floor(time * 12.0);
    vec2 seed = vec2(sin(frame * 1.345), cos(frame * 2.189));

    if (intensity > 0.0) {
        float nX = noise(uv * 18.0 + seed) - 0.5;
        float nY = noise(uv * 24.0 + seed * 1.5) - 0.5;
        // Subtle horizontal line interlacing wiggle from Slay the Princess shader.rpy
        float interlace = sin(uv.y * 120.0 + frame) * 0.0015;
        vec2 disp = vec2(nX * 0.003 + interlace, nY * 0.002) * intensity;
        uv += disp;
    }

    vec4 color = texture(source, uv);

    if (vignette > 0.0) {
        vec2 d = uv - vec2(0.5);
        float dist = length(d);
        float vig = smoothstep(0.4, 0.85, dist);
        color.rgb = mix(color.rgb, color.rgb * 0.4, vig * vignette);
    }

    fragColor = color * qt_Opacity;
}
