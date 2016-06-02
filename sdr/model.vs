#version 130
#uses lighting

uniform mat4 MVP;
uniform mat4 shadowBMVP;

#include header

in vec4 in_Position;
in vec3 in_Normal;
in vec4 in_TextureCoord;

out vec3 pass_Normal;
out vec4 pass_TextureCoord;
flat out int pass_materialNumber;

void main(void){
    prepareLightLocations();
    pass_TextureCoord = in_TextureCoord;
    pass_materialNumber = int(pass_TextureCoord.z);
    pass_Normal = normalize(N * in_Normal.xyz);
    gl_Position = MVP * in_Position;
}

#include source

