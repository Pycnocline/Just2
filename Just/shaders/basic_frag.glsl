#version 460

in vec2 texCoord;
in vec3 foliageColor;  // 顶点颜色
in vec2 lightMapCoords;   // 光照坐标
in vec3 geoNormal;    // 几何法线
in vec4 tangent;      // 切线

uniform sampler2D gtexture;     // 获取所有纹理
uniform sampler2D lightmap;     // 光照纹理
uniform sampler2D normals;      // 法线纹理
uniform sampler2D specular;     // 高光
uniform mat4 gbufferModelViewInverse;
uniform vec3 shadowLightPosition;   // 阴影光源位置

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

void main() {
    // 通过法线计算定向光照结果
    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * geoNormal;    // 世界坐标系法线
    vec3 worldTangent = mat3(gbufferModelViewInverse) * tangent.xyz;    // 世界坐标系切线
    

    // 处理带有法线的纹理
    vec4 normalData = texture(normals, texCoord) * 2.0 - 1.0;
    vec3 normalNormalSpace = vec3(normalData.xy, sqrt(1.0 - dot(normalData.xy, normalData.xy)));
    mat3 TBN = tbnNormalTangent(worldGeoNormal, worldTangent);
    vec3 normalWorldSpace = TBN * normalNormalSpace;

    float lightBrightness = clamp(dot(shadowLightDirection, normalWorldSpace), 0.2, 1.0);

    // 处理高光
    vec4 specularData = texture(specular, texCoord);
    float perceptualSmoothness = specularData.r;
    float roughness = pow(1.0 - perceptualSmoothness, 2.0); // 计算粗糙度

    // 根据方块的亮度等级获取光照纹理
    vec3 lightColor = pow(texture(lightmap, vec2(lightMapCoords)).rgb, vec3(2.2));  // 从光照纹理中获取颜色
    vec4 outputColorData = pow(texture(gtexture, texCoord), vec4(2.2));    // 从纹理中获取颜色赋值给outColor
    vec3 outputColor = outputColorData.rgb * pow(foliageColor,vec3(2.2)) * lightColor;    // 顶点颜色乘纹理颜色乘光照颜色
    
    outputColor *= lightBrightness;     // 乘光照亮度

    // 透明度检查
    float transparency = outputColorData.a;    // 获取透明度
    if (transparency < 0.1) {      // 如果透明度小于0.1那么识别为透明
        discard;
    }

    outColor0 = vec4(pow(outputColor, vec3(1 / 2.2)), transparency);    // 最终输出颜色
}