#version 130

uniform mat4 MVP;

in vec4 in_Position;
in vec4 in_Color;
in vec2 in_TextureCoord;

void main(){
    gl_Position = MVP * in_Position;
}
