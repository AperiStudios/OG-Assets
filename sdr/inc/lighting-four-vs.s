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
    pass_MVPos = MV * vec4(pos.xyz, 1.0);
    for(int i = 0; i < 4; i++){
        vec3 lightDir = pass_MPos.xyz - lights[i].position.xyz;
        float lightDepth = vecToDepth(lightDir);
        pass_PointShadowCoord[i] = vec4(normalize(lightDir),lightDepth-bias);
    }
}

