float getCubeMap(samplerCube cube, vec4 loc){
    float bias = 0.001;
    float vis = 1.0;
    if(texture(cube, loc.xyz).z < loc.w-bias){
        vis -= 0.2;
    }
    for (int i=0;i<4;i++){
      if ( texture( cube, vec3(loc.xy + poissonDisk[i]/700.0,loc.z )).z  <  loc.w-bias){
        vis-=0.2;
      }
    }
    return vis;
}

float getCubeMap(int light, vec4 loc){
  if(!showShadows) { return 1.0; }
  if(light == 0){ // Fucking Eww.
    return getCubeMap(cube0, loc);
  }else if(light == 1){
    return getCubeMap(cube1, loc);
  }else if(light == 2){
    return getCubeMap(cube2, loc);
  }else if(light == 3){
    return getCubeMap(cube3, loc);
  }else if(light == 4){
    return getCubeMap(cube4, loc);
  }else if(light == 5){
    return getCubeMap(cube5, loc);
  }else if(light == 6){
    return getCubeMap(cube6, loc);
  }else if(light == 7){
    return getCubeMap(cube7, loc);
  }
  return 0.0;
}

void getShadedColourLight(in int lightInd, inout vec4 colour, float shade)
{
  PointLightSource light = lights[lightInd];
  // Check Distance and lower ratio addition
  vec4 diff = pass_MPos - light.position;
  float distSq = pow(diff.x,2)+ pow(diff.y,2) + pow(diff.z,2);
  float intensity = 10/distSq;
//  float intensity = 1;
  if(intensity > 1){ intensity = 1; }
  float strength = 8*intensity*shade;
  colour += light.colour*strength;
}

float getLightShadow(int lightNumber){
  return getCubeMap(lightNumber, pass_PointShadowCoord[lightNumber]);
}

float getrandom(in vec4 seed4){
    float dot_product = dot(seed4, vec4(12.9898,78.233,45.164,94.673));
    return fract(sin(dot_product) * 43758.5453);
}

float getSunShadow(){
    if(!showShadows){ return 1.0; }
    float bias = 0.01;
    if(pass_ShadowCoord.x < 0.0 || pass_ShadowCoord.x > 1.0 || pass_ShadowCoord.y < 0.0 || pass_ShadowCoord.y > 1.0){
        return 1.0;
    }
    float vis = 1.0;
    if(texture(shadowMap, pass_ShadowCoord.xy).z < pass_ShadowCoord.z-bias){
        vis -= 0.2;
    }
    for (int i=0;i<4;i++){
      if ( texture( shadowMap, pass_ShadowCoord.xy + poissonDisk[i]/700.0 ).z  <  pass_ShadowCoord.z-bias){
        vis-=0.2;
      }
    }
    return vis;
//    return texture (shadowMap, vec3(pass_ShadowCoord.xy, pass_ShadowCoord.z-bias));
}

void getShadedColourSun (inout vec4 colour, in float shade){
  // Sun is a hardcoded light.
  vec4 white = vec4(1.0,1.0,1.0,1.0);
  // Sun is always highest power light. Maybe have this as moon at lower str in night?
  float strength = sunStr * shade; // TODO Daylight strength?
  colour += white * strength;
}

void lighting(inout vec4 ratios, inout vec4 specular, in vec3 N, in vec3 E, in float shininess, in vec4 colour, in vec4 dir,in float shadowAmmount, float power){
    shininess = clamp(shininess,0.0,1.0)*128.0;
    vec3 L = dir.xyz;
    float intensity = 1.0;
    if(power>0.0){
        if(dir.w>0.0){
            L = dir.xyz - pass_MPos.xyz;
        }
        float distSq = pow(L.x, 2.0) + pow(L.y, 2.0) + pow(L.z, 2.0);
        intensity = clamp(power/ distSq, 0.0, 1.0);
    }
    L = normalize(L);
    float d_factor = max(dot(N, L), 0.0);
    if(d_factor>0.0){
        d_factor = min(shadowAmmount, d_factor);
        vec3 R = normalize(reflect(L, N));
        float s_factor = pow(dot(E,R), shininess) * intensity * (1.0/shininess);
        if(s_factor>0.0 && shininess > 2.0){
            specular = specular + (s_factor * colour);
        }
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

mat3 cotangentFrame(vec3 N, vec3 p, vec2 uv){
    vec3 dp1 = dFdx(p);
    vec3 dp2 = dFdy(p);
    vec2 duv1 = dFdx(uv);
    vec2 duv2 = dFdy(uv);
    vec3 dp2perp = cross(dp2, N);
    vec3 dp1perp = cross(N, dp1);
    vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
    float invmax = inversesqrt(max(dot(T,T), dot(B,B)));
    return mat3(T * invmax, B * invmax, N);
}

vec3 perturbNormal(in vec3 N, in vec3 V, vec3 NA, vec2 texCoord){
    // Check for a blank/empty texture. Neither is useful to us, so return N
    if((NA.x == 1.0 && NA.y == 1.0 && NA.z == 1.0 ) ||
       (NA.x == 0.0 && NA.y == 0.0 && NA.z == 0.0 )){
        return N;
    }

    vec3 map = NA * 255./127. - 128./127.;
    mat3 TBN = cotangentFrame(N, V, texCoord);
    return normalize(TBN * map);
}

vec4 getShadedColour(in vec4 ambient, in vec4 normalAlter, in vec2 texCoord, in int matNum, in vec3 normal)
{
    normal = normalize(normal.xyz);
    normalAlter.xyz = normalize(normalAlter.xyz);
    vec3 eye = normalize(eyepos.xyz-pass_MPos.xyz);
    float shininess = 0.01;

    if(matNum != -1){
        Material mat = material[matNum];
        ambient = texture(arraytexture, vec3(texCoord, mat.textureindex*1.0));
        normalAlter = texture(arraytexturedata, vec3(texCoord, mat.texturedataindex*1.0));
        ambient = vec4(ambient.rgb * ambient.a + mat.colour.rgb * (1.0-ambient.a), 1.0);
    }
    shininess = max(0, normalAlter.a - 0.5);
    normal = perturbNormal(normal, pass_MVPos.xyz, normalAlter.xyz, texCoord);
    if(!showShadows){
        return colourToStyle(ambient);
    }
    vec4 diffuse = ambient * 0.8;
    ambient = ambient * 0.2;
    
    vec4 ratios = vec4(0.0, 0.0, 0.0, 0.0);
    vec4 specular = vec4(0.0, 0.0, 0.0, 0.0);
    lighting(ratios, specular, normal, eye, shininess, vec4(1.0,1.0,1.0,1.0), M*vec4(sunDir,0.0), getSunShadow(),0.0);
    for(int i = 0; i < 8; i++){
        PointLightSource light = lights[i];
        if(light.colour.r ==0 && light.colour.g == 0 && light.colour.b==0){
            continue;
        }
        lighting(ratios, specular, normal, eye, shininess, light.colour, light.position,getLightShadow(i), light.power);
     }
    return colourToStyle(ambient + (diffuse * ratios) + specular);
}
