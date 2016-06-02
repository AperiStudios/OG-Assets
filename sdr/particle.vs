#version 130

uniform mat4 MVP;
uniform float windowSizeScale;

in vec4 in_Position;
in vec4 in_Colour;
in vec4 in_Scale;

out vec4 pass_Colour;
out vec4 pass_Scale;

void main(){
    gl_Position = MVP * vec4(in_Position.xyz,1.0);
//    float scale = 1.0 - (sqrt(in_Scale.y)/100.0);
    float scale = 1.0/gl_Position.w;
    gl_Position = gl_Position / gl_Position.w;
    scale = max(scale, 0.01);
    scale = min(scale, 1.0);
    gl_PointSize = 10.0 * in_Scale.x*windowSizeScale*scale;
    pass_Colour = in_Colour;
    pass_Scale = in_Scale;
}
