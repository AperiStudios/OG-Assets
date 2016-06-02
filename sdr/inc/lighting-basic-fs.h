float getCubeMap(int light, vec4 loc);
void getShadedColourLight(in int lightInd, inout vec4 colour, float shade);
float getLightShadow(int lightNumber);
float getSunShadow();
void getShadedColourSun (inout vec4 colour, in float shade);
vec4 getShadedColour(in vec4 ambient, in vec4 normalAlter, in vec2 texCoord, in
 int matNum, in vec3 normal);

struct PointLightSource
{
  vec4 colour;
  vec4 position;
  float power;
};

struct Material
{
  vec4 colour;
  float textureindex, texturedataindex;
};

uniform bool showShadows;
uniform int lightCount=4;
uniform int renderStyle=0;
uniform sampler2DArray arraytexture, arraytexturedata;
uniform sampler2D shadowMap;
uniform PointLightSource lights[4];
uniform Material material[4];
uniform float sunStr;
uniform mat4 V;
uniform mat4 M;
uniform mat4 MV;
uniform vec3 sunDir;
uniform vec3 eyepos;

const vec2 poissonDisk[4] = vec2[](
  vec2( -0.94201624, -0.39906216 ),
  vec2( 0.94558609, -0.76890725 ),
  vec2( -0.094184101, -0.92938870 ),
  vec2( 0.34495938, 0.29387760 )
);

in vec4 pass_MPos;
in vec4 pass_MVPos;
in vec4 pass_ShadowCoord;
in vec3 pass_LightDir[4];

