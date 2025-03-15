mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    vec3 bitangent = cross(tangent, normal);
    return mat3(tangent, bitangent, normal);
}

float lightingCalculations() {
    // 光照
    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * geoNormal;    // 世界坐标系法线
    vec3 worldTangent = mat3(gbufferModelViewInverse) * tangent.xyz;    // 世界坐标系切线
    

    // 法线计算
    vec4 normalData = texture(normals, texCoord) * 2.0 - 1.0;
    vec3 normalNormalSpace = vec3(normalData.xy, sqrt(1.0 - dot(normalData.xy, normalData.xy)));
    mat3 TBN = tbnNormalTangent(worldGeoNormal, worldTangent);
    vec3 normalWorldSpace = TBN * normalNormalSpace;

    //  材质相关
    vec4 specularData = texture(specular, texCoord);
    float perceptualSmoothness = specularData.r;
    float roughness = pow(1.0 - perceptualSmoothness, 2.0); // 计算粗糙度
    float smoothness = 1.0 - roughness; // 计算光滑度
    float shininess = (1 + (smoothness) * 100);

    // 方向计算
    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
    vec3 reflectionDirection = reflect(-shadowLightDirection, normalWorldSpace);    // 计算反射方向
    vec3 fragFeetPlayerSpace = (gbufferModelViewInverse * vec4(viewSpacePosition, 1.0)).xyz;
    vec3 fragWorldSpace = fragFeetPlayerSpace + cameraPosition;
    vec3 viewDirection = normalize(cameraPosition - fragWorldSpace);

    // 反射相关
    float diffuseLight = roughness * clamp(dot(shadowLightDirection, normalWorldSpace), 0.0, 1.0);
    float specularLight = clamp(smoothness * pow(dot(reflectionDirection, viewDirection), shininess), 0.0, 1.0);
    vec3 ambientLightDirection = worldGeoNormal;

    float ambientLight = 0.2 * clamp(dot(ambientLightDirection, normalWorldSpace), 0.0, 1.0);    // 环境光
    float lightBrightness = ambientLight + diffuseLight + specularLight;

    return lightBrightness;
}