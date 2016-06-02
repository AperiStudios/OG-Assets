void getShadedColourSun (inout vec4 colour, in float shade);
vec4 getShadedColour(in vec4 ambient, in vec4 normalAlter, in vec2 texCoord, in
 int matNum, in vec3 normal);

struct Material
{
  vec4 colour;
  float textureindex, texturedataindex;
};

uniform int renderStyle=0;
uniform sampler2DArray arraytexture, arraytexturedata;
uniform Material material[4];
uniform vec3 eyepos;
uniform vec4 pass_MPos;
uniform bool showShadows;
uniform mat4 M;
uniform vec3 sunDir;


