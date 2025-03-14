#version 460

in vec3 vaPosition;     // 顶点坐标
in vec2 vaUV0;          // 纹理UV坐标
in vec4 vaColor;        // 顶点颜色
in ivec2 vaUV2;         // 块亮度图，ivec2:整型
in vec3 vaNormal;       // 顶点法线

uniform vec3 chunkOffset;       // 块偏移量
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 gbufferModelViewInverse;
uniform mat3 normalMatrix;

out vec2 texCoord;    // 纹理坐标 texture coordinate
out vec3 foliageColor;  // 顶点颜色
out vec2 lightMapCoords;   // 光照坐标
out vec3 geoNormal;    // 几何法线

void main() {
    geoNormal = normalMatrix * vaNormal;    // 面法线赋值给geoNormal

    texCoord = vaUV0;   // 纹理坐标赋值给texCoord
    foliageColor = vaColor.rgb;     // 顶点颜色赋值给foliageColor
    lightMapCoords = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);     // 光照坐标赋值给lightMapCoords

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);       // 转变为裁剪坐标系赋值给gl_Position
}