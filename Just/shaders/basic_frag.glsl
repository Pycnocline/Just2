#version 460

uniform sampler2D gtexture;     // 获取所有纹理
uniform sampler2D lightmap;     // 光照纹理

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

in vec2 texCoord;
in vec3 foliageColor;  // 顶点颜色
in vec2 lightMapCoords;   // 光照坐标

void main() {
    vec3 lightColor = pow(texture(lightmap, vec2(lightMapCoords)).rgb, vec3(2.2));  // 从光照纹理中获取颜色

    vec4 outputColorData = pow(texture(gtexture, texCoord), vec4(2.2));    // 从纹理中获取颜色赋值给outColor
    vec3 outputColor = outputColorData.rgb * pow(foliageColor,vec3(2.2)) * lightColor;    // 顶点颜色乘纹理颜色乘光照颜色

    float transparency = outputColorData.a;    // 获取透明度
    if (transparency < 0.1) {      // 如果透明度小于0.1那么识别为透明
        discard;
    }

    outColor0 = pow(vec4(outputColor, transparency), vec4(1/2.2));    // 最终输出颜色
}