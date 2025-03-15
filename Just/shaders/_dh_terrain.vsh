#version 460 compatibility

uniform mat4 dhProjection;
uniform mat4 textureMatrix;

out vec4 blockColor;  // 顶点颜色
out vec2 lightMapCoords;   // 光照坐标

void main() {
    blockColor = gl_Color;     // 顶点颜色赋值给foliageColor

    lightMapCoords = (textureMatrix * gl_MultiTexCoord2).xy;

    gl_Position = ftransform();

    
}