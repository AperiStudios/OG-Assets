#version 130

out vec4 fragcol;
void main(){
    float z = gl_FragCoord.z;
    fragcol = vec4(z,z,z,1);
}
