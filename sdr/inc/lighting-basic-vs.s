float vecToDepth (vec3 Vec)
{
  vec3  AbsVec     = abs (Vec);
  float LocalZcomp = max (AbsVec.x, max (AbsVec.y, AbsVec.z));

  const float n = 1;
  const float f = 50;

  float NormZComp = (f+n) / (f-n) - (2.0*f*n)/(f-n)/LocalZcomp;
  return (NormZComp + 1.0) * 0.5;
}

void prepareLightLocations(){
    prepareLightLocations(in_Position);
} 

void prepareLightLocations(in vec4 pos){
    float bias = 0.001;
    pass_ShadowCoord = shadowBMVP * vec4(pos.xyz, 1.0);
    pass_MPos = M * vec4(pos.xyz, 1.0);
    pass_MVPos = M * vec4(pos.zyz, 1.0);
}

