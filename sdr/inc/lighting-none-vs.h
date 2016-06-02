#pragma optionNV(unroll all)
void prepareLightLocations();
void prepareLightLocations(in vec4 pos);

uniform mat4 M;
uniform mat4 MV;
uniform mat3 N;

out vec4 pass_MPos;

