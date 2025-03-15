#version 460 compatibility

in vec4 blockColor;  // 顶点颜色
in vec2 lightMapCoords;   // 光照坐标

uniform sampler2D lightmap;     // 光照纹理
uniform sampler2D depthtex0;
uniform float viewWidth;
uniform float viewHeight;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

void main() {
    // 根据方块的亮度等级获取光照纹理
    vec3 lightColor = pow(texture(lightmap, lightMapCoords).rgb, vec3(2.2));  // 从光照纹理中获取颜色
    vec4 outputColorData = blockColor;
    vec3 outputColor = pow(outputColorData.rgb, vec3(2.2)) * lightColor;

    // 透明度检查
    float transparency = outputColorData.a;    // 获取透明度
    if (transparency < 0.1) {      // 如果透明度小于0.1那么识别为透明
        discard;
    }

    // 遮挡处理
    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture(depthtex0, texCoord).r;
    if (depth != 1.0) {
        discard;
    }
    outColor0 = pow(vec4(outputColor,transparency), vec4(1.0 / 2.2));    // 最终输出颜色
}