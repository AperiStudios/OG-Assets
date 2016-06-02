#version 130

uniform mat4 guiMatrix;
uniform mat4 modelMatrix;
uniform vec4 pickCol;

in vec4 in_Position;

out vec4 pass_Color;

void main(){
    gl_Position = guiMatrix * modelMatrix * in_Position;
    pass_Color = pickCol;
}
