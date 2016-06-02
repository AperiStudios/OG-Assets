#version 130
#uses lighting

#include header

in vec4 pass_Color;
in vec3 pass_Normal;
in vec3 pass_TextureCoord;
flat in int pass_materialNumber;

out vec4 out_Color;

void main(void){
    vec4 tex = vec4(pass_TextureCoord.xy,0.0,1.0);
    vec4 dud = vec4(1.0,1.0,1.0,1.0);
    out_Color = getShadedColour(tex,dud,pass_TextureCoord.xy,pass_materialNumber, pass_Normal.xyz);
}

#include source

