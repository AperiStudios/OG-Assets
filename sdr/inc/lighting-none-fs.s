void lighting(inout vec4 ratios, inout vec4 specular, in vec3 N, in vec3 E, in float shininess, in vec4 colour, in vec4 dir,in float shadowAmmount, float power){
    vec3 L = dir.xyz;
    float intensity = 1.0;
    if(power>0.0){
        if(dir.w>0.0){
            L = dir.xyz - pass_MPos.xyz;
        }
        float distSq = pow(L.x,2.0) + pow(L.y, 2.0) + pow(L.z, 2.0);
        intensity = clamp(power/distSq, 0.0, 1.0);
    }
    L = normalize(L);
    float d_factor = max(dot(N, L), 0.0);
    if(d_factor>0.0){
        d_factor = min(shadowAmmount, d_factor);
        d_factor = clamp(d_factor, 0.0, 1.0) * intensity;
        ratios = ratios + (d_factor * colour);
    }
}

vec4 colourToStyle(in vec4 col)
{
  if(renderStyle==1){
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));
    return vec4(gray, gray, gray, col.a);
  }else if(renderStyle==2){
    return vec4(
        clamp(col.r * 0.393 + col.g * 0.769 + col.b * 0.189, 0.0, 1.0),
        clamp(col.r * 0.349 + col.g * 0.686 + col.b * 0.168, 0.0, 1.0),
        clamp(col.r * 0.272 + col.g * 0.534 + col.b * 0.131, 0.0, 1.0),
        col.a 
        );
  }else if(renderStyle==3){
    return vec4(0.0,1.0,0.0,1.0);
  }
  return col;
}


vec4 getShadedColour(in vec4 ambient, in vec4 normalAlter, in vec2 texCoord, in
 int matNum, in vec3 normal)
{
    normal = normalize(normal.xyz);
    float shininess = 0.01;
    if(matNum != -1){
        Material mat = material[matNum];
        ambient = texture(arraytexture, vec3(ambient.xy, mat.textureindex*1.0));
        ambient = vec4(ambient.rgb * ambient.a + mat.colour.rgb * (1.0-ambient.a), 1.0);
    }
    if(!showShadows){
        return colourToStyle(ambient);
    }
    vec4 diffuse = ambient * 0.8;
    ambient = ambient * 0.2;

    vec4 ratios = vec4(0.0, 0.0, 0.0, 0.0);
    vec4 specular = vec4(0.0,0.0,0.0,0.0);

    lighting(ratios, specular, normal, vec3(0.0), shininess, vec4(1.0,1.0,1.0,1.0), M*vec4(sunDir, 0.0), 1.0, 0.0);
    return colourToStyle(ambient + (diffuse * ratios));
}
