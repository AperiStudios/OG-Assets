#version 130

uniform mat4 guiMatrix;
uniform mat4 modelMatrix;

in vec4 in_Position;
in vec4 in_Color;
in vec3 in_TextureCoord;

out vec4 pass_Color;
out vec3 pass_TextureCoord;

void main(){
    gl_Position = guiMatrix * modelMatrix * in_Position;
    pass_Color = in_Color;
    pass_TextureCoord = in_TextureCoord;
}
