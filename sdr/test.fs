#version 130

uniform sampler2D shadowMap;

in vec2 pass_TextureCoord;

out vec4 out_Color;

void main(){
//    float z = texture(shadowMap, pass_TextureCoord).r;
//    float n = 0.1;
//    float f = 200;
 //   float c = (2.0 * n) / (f + n - z * (f - n));
//    out_Color = vec4(c,c,c,1);
    out_Color = texture(shadowMap, pass_TextureCoord.xy);
}
