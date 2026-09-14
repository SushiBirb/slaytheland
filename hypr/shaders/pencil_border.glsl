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
    vec4 center = texture(tex, v_texcoord);
    
    // Dynamic intensity (0.0 = completely bypass shader)
    float u_intensity = 0.35;
    if (u_intensity <= 0.01) {
        fragColor = center;
        return;
    }
    
    vec2 res = vec2(textureSize(tex, 0));
    vec2 onePixel = 1.0 / res;
    
    float c = luma(center.rgb);
    
    // Quick exit for mid/bright flat areas - guarantees text & flat light paper remain 100% crisp
    // Only dark lines (c < 0.48) or window border crimson/parchment colors can be affected
    bool isBorderTone = (center.r > 0.45 && center.g < 0.35 && center.b < 0.45) || // Crimson / dried blood
                        (center.r > 0.80 && center.g > 0.75 && center.b > 0.65);   // Antique parchment
    
    if (c >= 0.52 && !isBorderTone) {
        fragColor = center;
        return;
    }
    
    // Sample 4 cardinal neighbors for edge contrast
    float l = luma(texture(tex, v_texcoord - vec2(onePixel.x * 2.0, 0.0)).rgb);
    float r = luma(texture(tex, v_texcoord + vec2(onePixel.x * 2.0, 0.0)).rgb);
    float u = luma(texture(tex, v_texcoord - vec2(0.0, onePixel.y * 2.0)).rgb);
    float d = luma(texture(tex, v_texcoord + vec2(0.0, onePixel.y * 2.0)).rgb);
    
    float edge = abs(l + r + u + d - 4.0 * c);
    
    // Strict edge threshold: must have genuine contrast
    if (edge < 0.05) {
        fragColor = center;
        return;
    }
    
    // Authentic charcoal line detection:
    // Low luminance + high contrast edge = hand-drawn dark contrasting stroke
    float darkLineFactor = smoothstep(0.48, 0.12, c) * smoothstep(0.05, 0.25, edge);
    float borderFactor = isBorderTone ? smoothstep(0.04, 0.20, edge) : 0.0;
    
    float strokeFactor = max(darkLineFactor, borderFactor);
    if (strokeFactor <= 0.02) {
        fragColor = center;
        return;
    }
    
    vec2 px = v_texcoord * res;
    // Charcoal grain tooth: clumped graphite texture
    float grain = hash(px * 1.25);
    // Subtle cross-hatch stippling along the stroke
    float stipple = sin(px.x * 0.95 + px.y * 0.95) * 0.5 + 0.5;
    float graphiteMod = (grain * 0.65 + stipple * 0.35);
    
    // Modulate dark lines: deepens and breaks up charcoal strokes naturally
    // Never adds additive white blur to crisp edges
    vec3 shaded = center.rgb * (1.0 - (graphiteMod - 0.25) * strokeFactor * u_intensity * 0.45);
    fragColor = vec4(clamp(shaded, 0.0, 1.0), center.a);
}
