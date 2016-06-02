#version 130

uniform sampler2DArray arraytexture;

in vec4 pass_Color;
in vec3 pass_TextureCoord;

out vec4 out_Color;

void main(void){
    vec4 tex_Color = texture(arraytexture, pass_TextureCoord);
    out_Color = tex_Color * pass_Color;
}
