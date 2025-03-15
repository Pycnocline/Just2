in vec2 texCoord;
in vec3 foliageColor;  // 顶点颜色

uniform sampler2D gtexture;     // 获取所有纹理

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

void main() {
    vec4 outputColorData = texture(gtexture, texCoord);
    vec3 albedo = pow(outputColorData.rgb,vec3(2.2)) * pow(foliageColor,vec3(2.2));

    // 透明度检查
    float transparency = outputColorData.a;    // 获取透明度
    if (transparency < 0.1) {      // 如果透明度小于0.1那么识别为透明
        discard;
    }

    outColor0 = vec4(pow(albedo, vec3(1 / 2.2)), transparency);    // 最终输出颜色
}