#!/usr/bin/env bash
# ==============================================================================
# slaytheland: Dynamic Pencil Shader Intensity Controller
# Adjusts graphite tooth and line-boil hatching for Hyprland window borders live
# Supports both Hyprland Lua (hl.config eval) and legacy hyprctl keyword
# ==============================================================================
set -euo pipefail

INTENSITY="${1:-0.5}"

# If intensity is near zero, disable the screen shader
IS_ZERO=$(awk -v v="$INTENSITY" 'BEGIN { print (v <= 0.02) ? "1" : "0" }')
if [ "$IS_ZERO" = "1" ]; then
    hyprctl eval 'hl.config({ decoration = { screen_shader = "" } })' >/dev/null 2>&1 || true
    hyprctl keyword decoration:screen_shader "" >/dev/null 2>&1 || true
    exit 0
fi

# Target directory in user's hypr config
SHADER_DIR="$HOME/.config/hypr/shaders"
mkdir -p "$SHADER_DIR"

# Alternate between two filenames to guarantee Hyprland detects a config string change and recompiles instantly
CURRENT=$(hyprctl getoption decoration:screen_shader -j 2>/dev/null | jq -r '.str' 2>/dev/null || echo "")
if [[ "$CURRENT" == *"pencil_border_a.glsl"* ]]; then
    TARGET="$SHADER_DIR/pencil_border_b.glsl"
else
    TARGET="$SHADER_DIR/pencil_border_a.glsl"
fi

cat << 'GLSLEOF' > "$TARGET"
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
    
    // Detect window border colors ONLY when on an actual edge/boundary (edge > 0.03)
    // This strictly prevents grain from bleeding into flat window contents, documents, or light backgrounds
    float isBorderColor = 0.0;
    if (edge > 0.03) {
        if (center.r > 0.4 && center.g < 0.25 && center.b < 0.35) {
            isBorderColor = 1.0;
        } else if (center.r > 0.75 && center.g > 0.72 && center.b > 0.65) {
            isBorderColor = 0.7;
        }
    }
    
    float edgeFactor = clamp(edge * 2.0 + isBorderColor * 0.6, 0.0, 1.0);
    
    // Dynamic intensity passed from Quickshell slider
    float u_intensity = __INTENSITY__;
    
    if (edgeFactor > 0.12 && u_intensity > 0.01) {
        vec2 px = v_texcoord * res;
        // Calibrated subtle graphite tooth
        float grain = (hash(px * 1.3) - 0.5) * 0.18;
        // Fine cross-hatch pencil stroke
        float hatch = sin((px.x + px.y) * 1.5) * 0.07;
        
        vec3 shaded = center.rgb + (grain + hatch) * edgeFactor * u_intensity;
        fragColor = vec4(clamp(shaded, 0.0, 1.0), center.a);
    } else {
        fragColor = center;
    }
}
GLSLEOF

# Substitute intensity into shader
sed -i "s/__INTENSITY__/$INTENSITY/g" "$TARGET"

# Synchronize canonical pencil_border.glsl
cp -f "$TARGET" "$SHADER_DIR/pencil_border.glsl"

# Hot-reload in Hyprland (supports Lua and legacy .conf)
hyprctl eval "hl.config({ decoration = { screen_shader = '$TARGET' } })" >/dev/null 2>&1 || true
hyprctl keyword decoration:screen_shader "$TARGET" >/dev/null 2>&1 || true
