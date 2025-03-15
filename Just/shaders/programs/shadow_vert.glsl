#version 460 compatibility

//uniform mat4 textureMatrix;

out vec2 texCoord;    // 纹理坐标 texture coordinate
out vec3 foliageColor;  // 顶点颜色

void main() {
    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    foliageColor = gl_Color.rgb;     // 顶点颜色赋值给foliageColor

    gl_Position = ftransform();       // 转变为裁剪坐标系赋值给gl_Position

    float distanceFromPlayer = length(gl_Position.xy);

    gl_Position.xy = gl_Position.xy / (0.1 + distanceFromPlayer);
}