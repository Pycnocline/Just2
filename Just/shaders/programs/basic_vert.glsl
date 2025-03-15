#version 460

in vec3 vaPosition;     // 顶点坐标
in vec2 vaUV0;          // 纹理UV坐标
in vec4 vaColor;        // 顶点颜色

uniform vec3 chunkOffset;       // 块偏移量
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

out vec2 texCoord;    // 纹理坐标 texture coordinate
out vec3 foliageColor;  // 顶点颜色

void main() {
    texCoord = vaUV0;   // 纹理坐标赋值给texCoord
    foliageColor = vaColor.rgb;     // 顶点颜色赋值给foliageColor

    vec4 viewSpacePositionVec4 = modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);    // 顶点坐标转换到视图空间

    gl_Position = projectionMatrix * viewSpacePositionVec4;       // 转变为裁剪坐标系赋值给gl_Position
}