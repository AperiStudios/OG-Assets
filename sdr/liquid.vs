#version 130
#uses lighting
uniform sampler2D colours;
uniform sampler2D flows;

uniform mat4 MVP;
uniform mat4 shadowBMVP;
uniform int hidden;

#include header

in vec4 in_Position;
in vec4 in_Offset;
in vec3 in_Normal;

out vec3 pass_ColourCoord;
out vec4 pass_Offset;
out vec4 pass_Flow1;
out vec4 pass_Flow2;
out vec3 pass_Normal;

void main(){
    prepareLightLocations();
    ivec2 size = textureSize(colours, 0);
    pass_ColourCoord = vec3((in_Position.x+1.5)/size.x, (in_Position.y+1.5)/size.y, in_Position.w);
    gl_Position = MVP * vec4(in_Position.xyz,1.0);
    ivec2 pos = ivec2(int(in_Position.x-in_Offset.x)+1, int(in_Position.y-in_Offset.y)+1);
    pass_Flow1.xy = texelFetch(flows, pos,0).xy;
    pass_Flow1.zw = texelFetch(flows, pos+ivec2(1,0),0).xy;
    pass_Flow2.xy = texelFetch(flows, pos+ivec2(0,1),0).xy;
    pass_Flow2.zw = texelFetch(flows, pos+ivec2(1,1),0).xy;
    pass_Offset = in_Offset;
    pass_Normal = normalize(N * in_Normal);
}

#include source

