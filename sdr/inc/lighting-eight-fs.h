float getCubeMap(int light, vec4 loc);
void getShadedColourLight(in int lightInd, inout vec4 colour, float shade);
float getLightShadow(int lightNumber);
float getSunShadow();
void getShadedColourSun (inout vec4 colour, in float shade);
vec4 getShadedColour(in vec4 ambient, in vec4 normalAlter, in vec2 texCoord, in int matNum, in vec3 normal);

struct PointLightSource
{
  vec4 colour;
  vec4 position;
  float power;
};

struct Material
{
  vec4 colour;
  float textureindex,texturedataindex;
};

uniform bool showShadows;
uniform int lightCount=8;
uniform int renderStyle=0;
uniform sampler2D shadowMap;
uniform sampler2DArray arraytexture, arraytexturedata;
uniform PointLightSource lights[8];
uniform Material material[8];
uniform float sunStr;
uniform mat4 M;
uniform mat4 V;
uniform mat4 MV;
uniform vec3 sunDir;
uniform vec3 eyepos;

uniform samplerCube cube0;
uniform samplerCube cube1; // Cube Arrays are OpenGL >= 4.0
uniform samplerCube cube2; // Let's cheat
uniform samplerCube cube3;
uniform samplerCube cube4;
uniform samplerCube cube5;
uniform samplerCube cube6;
uniform samplerCube cube7;

const vec2 poissonDisk[4] = vec2[](
  vec2( -0.94201624, -0.39906216 ),
  vec2( 0.94558609, -0.76890725 ),
  vec2( -0.094184101, -0.92938870 ),
  vec2( 0.34495938, 0.29387760 )
);

in vec4 pass_MPos;
in vec4 pass_MVPos;
in vec4 pass_ShadowCoord;
in vec4 pass_PointShadowCoord[8];
in vec3 pass_LightDir[8];

