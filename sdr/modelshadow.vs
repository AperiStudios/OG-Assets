#version 130

uniform mat4 MVP;

in vec4 in_Position;

void main(void){
    gl_Position = MVP * in_Position;
}
