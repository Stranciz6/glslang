#version 450 core

in gl_PerVertex {
    float gl_CullDistance[3];
} gl_in[gl_MaxPatchVertices];

out gl_PerVertex {
    float gl_CullDistance[3];
} gl_out[];

void main()
{
    gl_out[0].gl_CullDistance[2] = gl_in[1].gl_CullDistance[2];
}
