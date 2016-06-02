#version 130

uniform mat4 MVP;

in vec4 in_Position;
in vec4 in_Colour;

out vec4 pass_Color;

void main(){
    gl_Position = MVP * in_Position;
    pass_Color = in_Colour;
}
