#pragma optionNV(unroll all)
void prepareLightLocations();
void prepareLightLocations(in vec4 pos);

uniform bool showShadows;
uniform int lightCount=4;
uniform mat4 M;
uniform mat4 MV;
uniform mat3 N;
struct PointLightSource
{
  vec4 colour;
  vec4 position;
  float power;
};

uniform PointLightSource lights[4];

out vec4 pass_ShadowCoord;
out vec4 pass_MPos;
out vec4 pass_MVPos;

