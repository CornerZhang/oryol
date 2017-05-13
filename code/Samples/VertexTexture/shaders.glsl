//------------------------------------------------------------------------------
//  see https://github.com/ashima/webgl-noise
//
@block NoiseUtil
//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//

vec3 mod289(vec3 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
    return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
    return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
{
    const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
    0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
    -0.577350269189626,  // -1.0 + 2.0 * C.x
    0.024390243902439); // 1.0 / 41.0
    // First corner
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);
    
    // Other corners
    vec2 i1;
    //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
    //i1.y = 1.0 - i1.x;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    // x0 = x0 - 0.0 + 0.0 * C.xx ;
    // x1 = x0 - i1 + 1.0 * C.xx ;
    // x2 = x0 - 1.0 + 2.0 * C.xx ;
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    
    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
    + i.x + vec3(0.0, i1.x, 1.0 ));
    
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m ;
    m = m*m ;
    
    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    
    // Normalise gradients implicitly by scaling m
    // Approximation of: m *= inversesqrt( a0*a0 + h*h );
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
    
    // Compute final noise value at P
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}
@end

//------------------------------------------------------------------------------
@vs plasmaVS
in vec4 position;
in vec2 texcoord0;
out vec2 uv;
void main() {
    gl_Position = position;
    uv = texcoord0;
}
@end

@fs plasmaFS
@include NoiseUtil
uniform fsParams {
    float time;
};
in vec2 uv;
out vec4 fragColor;
void main() {
    vec2 dx = vec2(time, 0.0);
    vec2 dy = vec2(0.0, time);
    vec2 dxy = vec2(time, time);
    
    float red;
    red  = (snoise((uv * 1.5) + dx) * 0.5) + 0.5;
    red += snoise((uv * 5.0) + dx) * 0.15;
    red += snoise((uv * 5.0) + dy) * 0.15;
    
    float green;
    green  = (snoise((uv * 1.5) + dy) * 0.5) + 0.5;
    green += snoise((uv * 5.0) + dy) * 0.15;
    green += snoise((uv * 5.0) + dx) * 0.15;

    float blue;
    blue  = (snoise((uv * 1.5) + dxy) * 0.5) + 0.5;
    blue += snoise((uv * 5.0) + dxy) * 0.15;
    blue += snoise((uv * 5.0) - dxy) * 0.15;
    
    float height = 0.0;
    height = (snoise((uv * 3.0) + dxy) * 0.5) + 0.5;
    height += snoise(uv * 20.0 + dy) * 0.1;
    height += snoise(uv * 20.0 - dy) * 0.1;
    
    // scale by 100 to check that the result isn't clamped to 1.0
    fragColor = vec4(red, green, blue, height * 0.2);
}
@end

@program PlasmaShader plasmaVS plasmaFS

//------------------------------------------------------------------------------
@vs planeVS
uniform vsParams {
    mat4 mvp;
};
uniform sampler2D tex;
in vec4 position;
in vec2 texcoord0;
out vec4 color;

void main() {
    color = texture(tex, texcoord0);
    vec4 pos = position;
    pos.y = color.w;
    color.w = 1.0;
    gl_Position = mvp * pos;
}
@end

@fs planeFS
in vec4 color;
out vec4 fragColor;
void main() {
    fragColor = color;
}
@end

@program PlaneShader planeVS planeFS

