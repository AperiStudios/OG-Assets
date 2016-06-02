#version 130
#uses lighting

uniform mat4 MVP;
uniform mat4 shadowBMVP;

uniform mat4 u_BoneTransform[128];

#include header

in vec4 in_Position;
in vec4 in_Normal;
in vec3 in_TextureCoord;
in vec4 in_BoneID;
in vec4 in_BoneWeight;

out vec4 pass_Color;
out vec3 pass_Normal;
out vec3 pass_TextureCoord;
flat out int pass_materialNumber;

void main(void){
    vec4 position = vec4(0.0,0.0,0.0,0.0);
    vec4 normal = vec4(0.0,0.0,0.0,0.0);
    float weight = 0.0;
    for(int i = 0; i < 4; i++){
        if( in_BoneID[i]  < 0 ){ break; }
        position = position + ( in_BoneWeight[i] * ( u_BoneTransform[int(in_BoneID[i])] * in_Position ) );
        normal = normal + ( in_BoneWeight[i] * ( u_BoneTransform[int(in_BoneID[i])] * in_Normal ) );
        weight = weight + in_BoneWeight[i];
    }
    float inv = 1 / weight;
    normal = normal * inv;
    position = position * inv;
    position.w = 1.0;
    pass_TextureCoord = in_TextureCoord;
    pass_Normal = normalize(N * normal.xyz);
    gl_Position = MVP * vec4(position.xyz,1.0);
    prepareLightLocations(position);
    pass_materialNumber = int(pass_TextureCoord.z);
}

#include source

