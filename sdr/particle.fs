#version 130

uniform sampler2DArray tex;
uniform int renderStyle;

in vec4 pass_Colour;
in vec4 pass_Scale;

out vec4 out_Colour;

vec4 colourToStyle(in vec4 col)
{
  if(renderStyle==1){
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    return vec4(gray, gray, gray, 1.0);
  }else if(renderStyle==2){
    return vec4(
        clamp(col.r * 0.393 + col.g * 0.769 + col.b * 0.189, 0.0, 1.0),
        clamp(col.r * 0.349 + col.g * 0.686 + col.b * 0.168, 0.0, 1.0),
        clamp(col.r * 0.272 + col.g * 0.534 + col.b * 0.131, 0.0, 1.0),
        1.0
        );
  }
  return col;
}

void main(void){
    out_Colour = colourToStyle(pass_Colour*texture(tex,vec3(gl_PointCoord.st,pass_Scale.y)));
//    out_Colour = pass_Colour;
}
