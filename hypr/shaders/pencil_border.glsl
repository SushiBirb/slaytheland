#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

float luma(vec3 c) { return dot(c, vec3(0.2126, 0.7152, 0.0722)); }

float hash(vec2 p) {
    vec3 q = fract(vec3(p.xyx) * 0.1031);
    q += dot(q, q.yzx + 33.33);
    return fract((q.x + q.y) * q.z);
}

void main() {
    vec2 res = vec2(textureSize(tex, 0));
    vec2 onePixel = 1.0 / res;
    
    // Center color
    vec4 center = texture(tex, v_texcoord);
    
    // Sample 4 neighbors for edge detection (Laplacian kernel)
    float c = luma(center.rgb);
    float l = luma(texture(tex, v_texcoord - vec2(onePixel.x * 2.0, 0.0)).rgb);
    float r = luma(texture(tex, v_texcoord + vec2(onePixel.x * 2.0, 0.0)).rgb);
    float u = luma(texture(tex, v_texcoord - vec2(0.0, onePixel.y * 2.0)).rgb);
    float d = luma(texture(tex, v_texcoord + vec2(0.0, onePixel.y * 2.0)).rgb);
    
    float edge = abs(l + r + u + d - 4.0 * c);
    
    // Detect window border crimson and parchment colors
    float isBorderColor = 0.0;
    if (center.r > 0.4 && center.g < 0.25 && center.b < 0.35) {
        isBorderColor = 1.0;
    } else if (center.r > 0.75 && center.g > 0.72 && center.b > 0.65) {
        isBorderColor = 0.7;
    }
    
    float edgeFactor = clamp(edge * 2.5 + isBorderColor * 0.8, 0.0, 1.0);
    
    if (edgeFactor > 0.12) {
        // Apply pencil sketch tooth and line boil jitter strictly to edges/borders
        vec2 px = v_texcoord * res;
        float grain = (hash(px * 1.5) - 0.5) * 0.4;
        float hatch = sin((px.x + px.y) * 1.8) * 0.15;
        vec3 shaded = center.rgb + (grain + hatch) * edgeFactor;
        fragColor = vec4(clamp(shaded, 0.0, 1.0), center.a);
    } else {
        // Window contents and background remain completely unwarped and clear
        fragColor = center;
    }
}
