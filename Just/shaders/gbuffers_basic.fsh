#version 460

uniform sampler2D gtexture;     // 获取所有纹理

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

in vec2 texCoord;

void main() {
    outColor0 = texture(gtexture, texCoord);    // 从纹理中获取颜色赋值给outColor0
}