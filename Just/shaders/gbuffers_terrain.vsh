#version 460

in vec3 vaPosition;     // 顶点坐标
in vec2 vaUV0;          // 纹理UV坐标

uniform vec3 chunkOffset;       // 块偏移量
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;

out vec2 texCoord;    // 纹理坐标 texture coordinate

void main() {
    texCoord = vaUV0;   // 纹理坐标赋值给texCoord

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);       // 转变为裁剪坐标系赋值给gl_Position
}