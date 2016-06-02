#version 130
#uses lighting

uniform sampler2D colours;

#include header

in vec3 pass_TextureCoord;
in vec3 pass_TexIndex;
in vec3 pass_TexInfluence; 
in vec2 pass_HeightColourCoord;
in vec3 pass_Normal;

out vec4 out_Color;

void main(){
    // Sample 1
    vec3 pos = vec3(pass_TextureCoord.xy, pass_TexIndex.x);
    vec4 tex1_Color = texture(arraytexture, pos);
    vec4 norm1_Color = texture(arraytexturedata, pos);

    // Sample 2
    pos.z= pass_TexIndex.y;
    vec4 tex2_Color = texture(arraytexture, pos);
    vec4 norm2_Color = texture(arraytexturedata, pos);

    // Sample 3
    pos.z= pass_TexIndex.z;
    vec4 tex3_Color = texture(arraytexture, pos);
    vec4 norm3_Color = texture(arraytexturedata, pos);

    // Mix
    vec4 tex_Color = (tex1_Color * pass_TexInfluence.x) + (tex2_Color * pass_TexInfluence.y) + (tex3_Color * pass_TexInfluence.z);
    vec4 norm_Color = (norm1_Color * pass_TexInfluence.x) + (norm2_Color * pass_TexInfluence.y) + (norm3_Color * pass_TexInfluence.z);

    vec4 plainColor = texture(colours, pass_HeightColourCoord);

    out_Color = getShadedColour(tex_Color * plainColor, norm_Color, pass_TextureCoord.xy, -1, pass_Normal);



//    out_Color = vec4((tex_Color * texture(colours, pass_HeightColourCoord) * vis).xyz, 1);
//    out_Color = pass_Color;
}

#include source

