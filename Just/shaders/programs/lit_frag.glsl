#version 460

in vec2 texCoord;
in vec3 foliageColor;  // 顶点颜色
in vec2 lightMapCoords;   // 光照坐标
in vec3 geoNormal;    // 几何法线
in vec4 tangent;      // 切线
in vec3 viewSpacePosition;

uniform sampler2D gtexture;     // 获取所有纹理
uniform sampler2D lightmap;     // 光照纹理
uniform sampler2D normals;      // 法线纹理
uniform sampler2D specular;     // 高光
uniform mat4 gbufferModelViewInverse;
uniform vec3 shadowLightPosition;   // 阴影光源位置
uniform vec3 cameraPosition;    // 相机位置

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

#include "/programs/functions.glsl"

void main() {
    


    // 根据方块的亮度等级获取光照纹理
    vec3 lightColor = pow(texture(lightmap, lightMapCoords).rgb, vec3(2.2));  // 从光照纹理中获取颜色

    vec4 outputColorData = texture(gtexture, texCoord);    // 从纹理中获取颜色赋值给outColor
    vec3 outputColor = pow(outputColorData.rgb, vec3(2.2)) * pow(foliageColor,vec3(2.2)) * lightColor;    // 顶点颜色乘纹理颜色乘光照颜色
    
    outputColor *= lightingCalculations();     // 乘光照亮度

    // 透明度检查
    float transparency = outputColorData.a;    // 获取透明度
    if (transparency < 0.1) {      // 如果透明度小于0.1那么识别为透明
        discard;
    }

    outColor0 = vec4(pow(outputColor, vec3(1 / 2.2)), transparency);    // 最终输出颜色
}