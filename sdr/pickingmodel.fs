#version 130

uniform vec4 pickCol;

out vec4 out_Color;

void main(void){
    out_Color = pickCol;
}
