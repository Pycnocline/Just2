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
uniform sampler2D shadowtex0;   // 阴影纹理
uniform sampler2D shadowcolor0; // 阴影颜色
uniform sampler2D shadowtex1;   // 阴影纹理,忽略透明物体
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;   // 阴影光源位置
uniform vec3 cameraPosition;    // 相机位置
uniform float viewWidth;    // 视图宽度
uniform float viewHeight;   // 视图高度

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

#include "/programs/functions.glsl"

void main() {
    vec4 outputColorData = texture(gtexture, texCoord);    // 从纹理中获取颜色赋值给outColor
    vec3 albedo = pow(outputColorData.rgb, vec3(2.2)) * pow(foliageColor,vec3(2.2));    // 顶点颜色乘纹理颜色乘光照颜色
    
    // 透明度检查
    float transparency = outputColorData.a;    // 获取透明度
    if (transparency < 0.1) {      // 如果透明度小于0.1那么识别为透明
        discard;
    }

    vec3 outputColor = lightingCalculations(albedo);    // 计算光照

    outColor0 = vec4(pow(outputColor, vec3(1 / 2.2)), transparency);    // 最终输出颜色
}