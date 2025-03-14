#version 460

uniform sampler2D gtexture;     // 获取所有纹理
uniform sampler2D lightmap;     // 光照纹理
uniform mat4 gbufferModelViewInverse;
uniform vec3 shadowLightPosition;   // 阴影光源位置

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

in vec2 texCoord;
in vec3 foliageColor;  // 顶点颜色
in vec2 lightMapCoords;   // 光照坐标
in vec3 geoNormal;    // 几何法线

void main() {
    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * geoNormal;    // 世界坐标系法线

    float lightBrightness = clamp(dot(shadowLightDirection, worldGeoNormal), 0.2, 1.0);

    vec3 lightColor = pow(texture(lightmap, vec2(lightMapCoords)).rgb, vec3(2.2));  // 从光照纹理中获取颜色

    vec4 outputColorData = pow(texture(gtexture, texCoord), vec4(2.2));    // 从纹理中获取颜色赋值给outColor
    vec3 outputColor = outputColorData.rgb * pow(foliageColor,vec3(2.2)) * lightColor;    // 顶点颜色乘纹理颜色乘光照颜色

    float transparency = outputColorData.a;    // 获取透明度
    if (transparency < 0.1) {      // 如果透明度小于0.1那么识别为透明
        discard;
    }

    outputColor *= lightBrightness;     // 乘光照亮度
    outColor0 = vec4(pow(outputColor, vec3(1 / 2.2)), transparency);    // 最终输出颜色
}