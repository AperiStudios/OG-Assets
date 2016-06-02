#version 130
#uses lighting

uniform sampler2D colours;

#include header

in vec3 pass_ColourCoord;
in vec4 pass_Offset;
in vec4 pass_Flow1;
in vec4 pass_Flow2;
in vec3 pass_Normal;

out vec4 out_Color;

void main(){
    // Sample 1
    vec3 pos = vec3(pass_Flow1.xy+pass_Offset.xy,pass_ColourCoord.z);
    float attenuator = (1.0 - pass_Offset.x) * (1.0 - pass_Offset.y);
    vec4 tex_Color1 = texture(arraytexture,pos) * attenuator;
    vec4 norm_Color1 = texture(arraytexturedata,pos) * attenuator;

    // Sample 2
    pos = vec3(pass_Flow1.zw+pass_Offset.xy,pass_ColourCoord.z);
    attenuator = pass_Offset.x * (1.0 - pass_Offset.y);
    vec4 tex_Color2 = texture(arraytexture,pos) * attenuator;
    vec4 norm_Color2 = texture(arraytexturedata,pos) * attenuator;


    // Sample 3
    pos = vec3(pass_Flow2.xy+pass_Offset.xy,pass_ColourCoord.z);
    attenuator = (1.0-pass_Offset.x) * pass_Offset.y;
    vec4 tex_Color3 = texture(arraytexture,pos) * attenuator;
    vec4 norm_Color3 = texture(arraytexturedata,pos) * attenuator;

    // Sample 4
    pos = vec3(pass_Flow2.zw+pass_Offset.xy,pass_ColourCoord.z);
    attenuator = pass_Offset.x * pass_Offset.y;
    vec4 tex_Color4 = texture(arraytexture,pos) * attenuator;
    vec4 norm_Color4 = texture(arraytexturedata,pos) * attenuator;

    // Mix samples
    vec4 tex_Color = tex_Color1 + tex_Color2 + tex_Color3 + tex_Color4;
    vec4 norm_Color = norm_Color1 + norm_Color2 + norm_Color3 + norm_Color4;

    vec4 plainColor = texture(colours, pass_ColourCoord.xy);

    out_Color = getShadedColour(tex_Color * plainColor, norm_Color, pass_Offset.xy, -1, pass_Normal);



//    out_Color = vec4((tex_Color * texture(colours, pass_HeightColourCoord) * vis).xyz, 1);
//    out_Color = pass_Color;
}

#include source

