#!/usr/bin/env bash
# ==============================================================================
# slaytheland: Dynamic Pencil Shader Intensity Controller
# Adjusts graphite tooth and line-boil hatching for Hyprland window borders live
# Supports both Hyprland Lua (hl.config eval) and legacy hyprctl keyword
# ==============================================================================
set -euo pipefail

INTENSITY="${1:-0.5}"

# Security validation: Ensure intensity is strictly a numeric float to prevent injection
if ! [[ "$INTENSITY" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Error: Invalid intensity value '$INTENSITY'. Must be a numeric float between 0.0 and 1.0." >&2
    exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# If intensity is near zero, disable the screen shader
IS_ZERO=$(awk -v v="$INTENSITY" 'BEGIN { print (v <= 0.02) ? "1" : "0" }')
if [ "$IS_ZERO" = "1" ]; then
    hyprctl eval 'hl.config({ decoration = { screen_shader = "" } })' >/dev/null 2>&1 || true
    hyprctl keyword decoration:screen_shader "" >/dev/null 2>&1 || true
    # Also update file with 0.0 intensity so direct file references immediately clear
    INTENSITY="0.0"
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

// High quality pseudo-random hash for graphite tooth
float hash(vec2 p) {
    vec3 q = fract(vec3(p.xyx) * 0.1031);
    q += dot(q, q.yzx + 33.33);
    return fract((q.x + q.y) * q.z);
}

void main() {
    vec4 center = texture(tex, v_texcoord);
    
    // Dynamic intensity (0.0 = completely bypass shader)
    float u_intensity = __INTENSITY__;
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
GLSLEOF

# Substitute intensity into shader
sed -i "s/__INTENSITY__/$INTENSITY/g" "$TARGET"

# Synchronize canonical pencil_border.glsl in config and repo directories
cp -f "$TARGET" "$SHADER_DIR/pencil_border.glsl"
if [ -d "$ROOT/hypr/shaders" ]; then
    cp -f "$TARGET" "$ROOT/hypr/shaders/pencil_border.glsl"
fi
if [ -d "$HOME/slaytheland/hypr/shaders" ]; then
    cp -f "$TARGET" "$HOME/slaytheland/hypr/shaders/pencil_border.glsl"
fi
if [ -d "/home/arch/slaytheland/hypr/shaders" ]; then
    cp -f "$TARGET" "/home/arch/slaytheland/hypr/shaders/pencil_border.glsl" 2>/dev/null || true
fi

# Hot-reload in Hyprland (supports Lua and legacy .conf)
if [ "$IS_ZERO" = "1" ]; then
    hyprctl eval 'hl.config({ decoration = { screen_shader = "" } })' >/dev/null 2>&1 || true
    hyprctl keyword decoration:screen_shader "" >/dev/null 2>&1 || true
else
    hyprctl eval "hl.config({ decoration = { screen_shader = '$TARGET' } })" >/dev/null 2>&1 || true
    hyprctl keyword decoration:screen_shader "$TARGET" >/dev/null 2>&1 || true
fi
