// ATLAS CRT Shader - Orange Retro Terminal Aesthetic
// Modified for the EPOCH terminal renderer
// Based on: https://www.shadertoy.com/view/WsVSzV
// Licensed under CC BY NC SA 3.0

// CRT Parameters
float warp = 0.25;      // curvature of CRT monitor
float scan = 0.75;      // darkness between scanlines (increased for more pronounced effect)
float brightness = 1.1;  // overall brightness boost
float glow = 0.15;      // phosphor glow intensity

// Orange color grading
vec3 orangeTint = vec3(1.0, 0.4, 0.0); // #FF6600 orange
float saturation = 1.2; // boost orange saturation

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // squared distance from center for vignette and warp
    vec2 uv = fragCoord / iResolution.xy;
    vec2 dc = abs(0.5 - uv);
    dc *= dc;

    // warp the fragment coordinates (CRT curvature)
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

    // check if we're outside the warped screen bounds
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // sample the texture
    vec3 color = texture(iChannel0, uv).rgb;

    // apply orange tint to bright areas
    float luminance = dot(color, vec3(0.299, 0.587, 0.114));
    color = mix(color, color * orangeTint, luminance * 0.6);

    // boost saturation for orange channels
    color.r *= saturation;
    color.g *= (saturation * 0.7);

    // scanlines - horizontal lines with varying intensity
    float scanline = sin(fragCoord.y * 2.0) * 0.5 + 0.5;
    float scanlineIntensity = 1.0 - (scanline * scan);
    color *= scanlineIntensity;

    // phosphor glow effect (bloom on bright areas)
    vec3 glowColor = vec3(0.0);
    for (float i = -2.0; i <= 2.0; i += 1.0) {
        for (float j = -2.0; j <= 2.0; j += 1.0) {
            vec2 offset = vec2(i, j) / iResolution.xy;
            glowColor += texture(iChannel0, uv + offset).rgb;
        }
    }
    glowColor /= 25.0;
    glowColor *= orangeTint;
    color += glowColor * glow * luminance;

    // vignette effect (darker edges)
    float vignette = 1.0 - (dc.x + dc.y) * 0.4;
    color *= vignette;

    // subtle chromatic aberration on edges
    float aberration = (dc.x + dc.y) * 0.003;
    float r = texture(iChannel0, uv + vec2(aberration, 0.0)).r;
    float b = texture(iChannel0, uv - vec2(aberration, 0.0)).b;
    color.r = mix(color.r, r, 0.5);
    color.b = mix(color.b, b, 0.3);

    // slight flicker effect (very subtle)
    float flicker = 0.995 + 0.005 * sin(iTime * 50.0);
    color *= flicker;

    // brightness boost
    color *= brightness;

    // noise/grain for authenticity (very subtle)
    float noise = fract(sin(dot(fragCoord.xy, vec2(12.9898, 78.233)) + iTime) * 43758.5453);
    color += vec3(noise * 0.02);

    // final output
    fragColor = vec4(color, 1.0);
}
