#version 460

in vec3 vaPosition;     // 顶点坐标
in vec2 vaUV0;          // 纹理UV坐标
in vec4 vaColor;        // 顶点颜色
in ivec2 vaUV2;         // 块亮度图，ivec2:整型
in vec3 vaNormal;       // 顶点法线
in vec4 at_tangent;     // 切线

uniform vec3 chunkOffset;       // 块偏移量
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 gbufferModelViewInverse;
uniform mat3 normalMatrix;

out vec2 texCoord;    // 纹理坐标 texture coordinate
out vec3 foliageColor;  // 顶点颜色
out vec2 lightMapCoords;   // 光照坐标
out vec3 viewSpacePosition;
out vec3 geoNormal;    // 几何法线
out vec4 tangent;      // 切线

void main() {
    tangent = vec4(normalize(normalMatrix * at_tangent.rgb), at_tangent.a);   // 切线赋值给tangent
    geoNormal = normalMatrix * vaNormal;    // 面法线赋值给geoNormal

    texCoord = vaUV0;   // 纹理坐标赋值给texCoord
    foliageColor = vaColor.rgb;     // 顶点颜色赋值给foliageColor
    lightMapCoords = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);     // 光照坐标赋值给lightMapCoords

    vec4 viewSpacePositionVec4 = modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);    // 顶点坐标转换到视图空间
    viewSpacePosition = viewSpacePositionVec4.xyz;
    gl_Position = projectionMatrix * viewSpacePositionVec4;       // 转变为裁剪坐标系赋值给gl_Position
}