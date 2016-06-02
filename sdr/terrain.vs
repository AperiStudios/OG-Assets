#version 130
#uses lighting
uniform sampler2D colours;
uniform mat4 MVP;
uniform mat4 shadowBMVP;
uniform int hidden;

#include header

in vec4 in_Position;
in vec3 in_TextureCoord;
in vec3 in_TexIndex;
in vec3 in_Normal;

out vec3 pass_TextureCoord;
out vec3 pass_TexIndex;
out vec3 pass_TexInfluence;
out vec2 pass_HeightColourCoord;
out vec3 pass_Normal;

void main(){
    prepareLightLocations();
    ivec2 size = textureSize(colours, 0);
    pass_HeightColourCoord = vec2((in_TextureCoord.x+1.5)/size.x, (in_TextureCoord.y+1.5)/size.y);
    gl_Position = MVP * in_Position;
    pass_TextureCoord = in_TextureCoord;
    pass_TexIndex = in_TexIndex;
    pass_Normal = normalize(N*in_Normal);
    if( pass_TexIndex.x == in_TextureCoord.z ){
        pass_TexInfluence = vec3(1.0,0.0,0.0);
    }else if(pass_TexIndex.y == in_TextureCoord.z){
        pass_TexInfluence = vec3(0.0,1.0,0.0);
    }else{
        pass_TexInfluence = vec3(0.0,0.0,1.0);
    }
}

#include source

