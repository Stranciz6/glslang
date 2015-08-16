#version 310 es

shared vec4 s;   // ERROR
layout(local_size_x = 2) out;  // ERROR
buffer vec4 v;  // ERROR

layout(location = 2) uniform mat4 x;
layout(location = 3) uniform mat4 y;
layout(location = 2) out mat4 xi;
layout(location = 3) out mat4 yi;  // ERROR, locations conflict with xi

void main()
{
    uvec2 u2;
    u2 = uaddCarry(u2, u2, u2);
    uint u1;
    u1 = usubBorrow(u1, u1, u1);
    uvec4 u4;
    umulExtended(u4, u4, u4, u4);
    ivec4 i4;
    imulExtended(i4, i4, i4, i4);
    int i1;
    i1 = bitfieldExtract(i1, 4, 5);
    uvec3 u3;
    u3 = bitfieldExtract(u3, 4, 5);
    ivec3 i3;
    i3 = bitfieldInsert(i3, i3, 4, 5);
    u1 = bitfieldInsert(u1, u1, 4, 5);
    ivec2 i2;
    i2 = bitfieldReverse(i2);
    u4 = bitfieldReverse(u4);
    i1 = bitCount(i1);
    i3 = bitCount(u3);
    i2 = findLSB(i2);
    i4 = findLSB(u4);
    i1 = findMSB(i1);
    i2 = findMSB(u2);

    vec3 v3;
    v3 = frexp(v3, i3);
    vec2 v2;
    v2 = ldexp(v2, i2);

    mediump vec4 v4;
    u1 = packUnorm4x8(v4);
    u1 = packSnorm4x8(v4);
    v4 = unpackUnorm4x8(u1);
    v4 = unpackSnorm4x8(u1);
}

precision highp sampler2DMS;
precision highp isampler2DMS;
precision highp usampler2DMS;

uniform sampler2DMS s2dms;
uniform isampler2DMS is2dms;
uniform usampler2DMS us2dms;
uniform usampler2DMSArray us2dmsa;   // ERROR

void foo()
{
    ivec2 v2;
    v2 = textureSize(s2dms);
    v2 = textureSize(us2dms);
    vec4 v4 = texelFetch(s2dms, v2, 2);
    ivec4 iv4 = texelFetch(is2dms, v2, 2);
    textureSamples(s2dms);   // ERROR


}

out bool outb;         // ERROR
out sampler2D outo;    // ERROR
out float outa[4];
out float outaa[4][2]; // ERROR
struct S { float f; };
out S outs;
out S[4] outasa;       // ERROR
out S outsa[4];        // ERROR
struct SA { float f[4]; };
out SA outSA;          // ERROR
struct SS { float f; S s; };
out SS outSS;          // ERROR

layout(std430) uniform U430 { int a; } U430i;    // ERROR
layout(std430) buffer B430 { int a; } B430i;

#ifndef GL_OES_shader_io_blocks
#error GL_OES_shader_io_blocks not defined
#endif

#extension GL_OES_shader_io_blocks : enable

out outbname {
    int a;
    out vec4 v;
    highp sampler2D s;   // ERROR, opaque type
} outbinst;

out outbname2 {
    layout(location = 12) int aAnon;
    layout(location = 13) vec4 vAnon;
};

layout(location = 12) out highp int aliased;  // ERROR, aliasing location

in inbname { int a; } inbinst;  // ERROR, no in block in vertex shader

out gl_PerVertex {              // ERROR, has extra member
    highp vec4 gl_Position;
    highp vec4 t;
};

void foo_IO()
{
    int sum  = gl_VertexID +
               gl_InstanceID;
    gl_Position = vec4(1.0);
    gl_PointSize = 2.0;         // ERROR, removed by redeclaration
}

out gl_PerVertex {              // ERROR, already used and already redeclared
    highp vec4 gl_Position;
    highp vec4 t;
};

smooth out smo {                // ERROR, no smooth on a block
    int i;
} smon;

flat out fmo {                  // ERROR, no flat on a block
    int i;
} fmon;

centroid out cmo {              // ERROR, no centroid on a block
    int i;
} cmon;

invariant out imo {             // ERROR, no invariant on a block
    int i;
} imon;

in vec2 inf, ing;
uniform ivec2 offsets[4];
uniform sampler2D sArray[4];
uniform int sIndex;
layout(binding = 0) uniform atomic_uint auArray[2];
uniform ubName { int i; } ubInst[4];
buffer bbName { int i; } bbInst[4];
uniform writeonly image2D iArray[5];
const ivec2 constOffsets[4] = ivec2[4](ivec2(0.1), ivec2(0.2), ivec2(0.3), ivec2(0.4));

void pfooBad()
{
    precise vec2 h;          // ERROR reserved
    h = fma(inf, ing, h);    // ERROR, not available
    sArray[sIndex + 1];      // ERRRO, not supported
    auArray[sIndex + 1];
    ubInst[1];
    bbInst[2];
    ubInst[sIndex + 1];      // ERRRO, not supported
    bbInst[sIndex];          // ERRRO, not supported
    iArray[2];
    iArray[sIndex * 2];      // ERRRO, not supported
    textureGatherOffset(sArray[0], vec2(0.1), ivec2(inf));     // ERROR, offset not constant
    textureGatherOffsets(sArray[0], vec2(0.1), constOffsets);  // ERROR, not available
}

#extension GL_OES_gpu_shader5 : enable

void pfoo()
{
    precise vec2 h;
    h = fma(inf, ing, h);
    sArray[sIndex + 1];
    ubInst[sIndex + 1];
    bbInst[sIndex - 2];      // ERROR, still not supported
    iArray[2];
    iArray[sIndex - 2];
    textureGatherOffset(sArray[0], vec2(0.1), ivec2(inf));
    textureGatherOffsets(sArray[0], vec2(0.1), constOffsets);
    textureGatherOffsets(sArray[0], vec2(0.1), offsets);   // ERROR, offset not constant
}

uniform samplerBuffer  badSamp1;             // ERROR, reserved
uniform isamplerBuffer badSamp2;             // ERROR, reserved
uniform usamplerBuffer badSamp3;             // ERROR, reserved
uniform writeonly imageBuffer    badSamp4;   // ERROR, reserved
uniform writeonly iimageBuffer   badSamp5;   // ERROR, reserved
uniform writeonly uimageBuffer   badSamp6;   // ERROR, reserved

#extension GL_OES_texture_buffer : enable
#extension GL_EXT_texture_buffer : enable

uniform samplerBuffer  noPreSamp1;            // ERROR, no default precision
uniform isamplerBuffer noPreSamp2;            // ERROR, no default precision
uniform usamplerBuffer noPreSamp3;            // ERROR, no default precision
uniform writeonly imageBuffer    noPreSamp4;  // ERROR, no default precision
uniform writeonly iimageBuffer   noPreSamp5;  // ERROR, no default precision
uniform writeonly uimageBuffer   noPreSamp6;  // ERROR, no default precision

precision highp samplerBuffer; 
precision highp isamplerBuffer;
precision highp usamplerBuffer;
precision highp imageBuffer;   
precision highp iimageBuffer;  
precision highp uimageBuffer;  

#ifdef GL_OES_texture_buffer
uniform samplerBuffer  bufSamp1;          
uniform isamplerBuffer bufSamp2;          
uniform usamplerBuffer bufSamp3;          
#endif
#ifdef GL_EXT_texture_buffer
uniform writeonly imageBuffer    bufSamp4;
uniform writeonly iimageBuffer   bufSamp5;
uniform writeonly uimageBuffer   bufSamp6;
#endif

void bufferT()
{
    highp int s1 = textureSize(bufSamp1);
    highp int s2 = textureSize(bufSamp2);
    highp int s3 = textureSize(bufSamp3);

    highp int s4 = imageSize(bufSamp4);
    highp int s5 = imageSize(bufSamp5);
    highp int s6 = imageSize(bufSamp6);
    
    highp vec4 f1 = texelFetch(bufSamp1, s1);
    highp ivec4 f2 = texelFetch(bufSamp2, s2);
    highp uvec4 f3 = texelFetch(bufSamp3, s3);
}

uniform writeonly imageCubeArray  badCA1;  // ERROR, reserved
uniform writeonly iimageCubeArray badCA2;  // ERROR, reserved
uniform writeonly uimageCubeArray badCA3;  // ERROR, reserved

uniform samplerCubeArray          badCA4;  // ERROR, reserved
uniform samplerCubeArrayShadow    badCA5;  // ERROR, reserved
uniform isamplerCubeArray         badCA6;  // ERROR, reserved
uniform usamplerCubeArray         badCA7;  // ERROR, reserved

#extension GL_OES_texture_cube_map_array : enable

uniform writeonly imageCubeArray  noPreCA1;   // ERROR, no default precision
uniform writeonly iimageCubeArray noPreCA2;   // ERROR, no default precision
uniform writeonly uimageCubeArray noPreCA3;   // ERROR, no default precision

uniform samplerCubeArray          noPreCA4;   // ERROR, no default precision
uniform samplerCubeArrayShadow    noPreCA5;   // ERROR, no default precision
uniform isamplerCubeArray         noPreCA6;   // ERROR, no default precision
uniform usamplerCubeArray         noPreCA7;   // ERROR, no default precision

precision highp imageCubeArray        ;
precision highp iimageCubeArray       ;
precision highp uimageCubeArray       ;

precision highp samplerCubeArray      ;
precision highp samplerCubeArrayShadow;
precision highp isamplerCubeArray     ;
precision highp usamplerCubeArray     ;

uniform writeonly imageCubeArray  CA1;
uniform writeonly iimageCubeArray CA2;
uniform writeonly uimageCubeArray CA3;

#ifdef GL_OES_texture_cube_map_array
uniform samplerCubeArray          CA4;
uniform samplerCubeArrayShadow    CA5;
uniform isamplerCubeArray         CA6;
uniform usamplerCubeArray         CA7;
#endif

void CAT()
{
    highp ivec3 s4 = textureSize(CA4, 1);
    highp ivec3 s5 = textureSize(CA5, 1);
    highp ivec3 s6 = textureSize(CA6, 1);
    highp ivec3 s7 = textureSize(CA7, 1);
    
    highp vec4 t4 = texture(CA4, vec4(0.5));
    highp float t5 = texture(CA5, vec4(0.5), 3.0);
    highp ivec4 t6 = texture(CA6, vec4(0.5));
    highp uvec4 t7 = texture(CA7, vec4(0.5));

    highp vec4 L4 = textureLod(CA4, vec4(0.5), 0.24);
    highp ivec4 L6 = textureLod(CA6, vec4(0.5), 0.26);
    highp uvec4 L7 = textureLod(CA7, vec4(0.5), 0.27);

    highp vec4 g4 = textureGrad(CA4, vec4(0.5), vec3(0.1), vec3(0.2));
    highp ivec4 g6 = textureGrad(CA6, vec4(0.5), vec3(0.1), vec3(0.2));
    highp uvec4 g7 = textureGrad(CA7, vec4(0.5), vec3(0.1), vec3(0.2));

    highp vec4 gath4 = textureGather(CA4, vec4(0.5));
    highp vec4 gathC4 = textureGather(CA4, vec4(0.5), 2);
    highp ivec4 gath6 = textureGather(CA6, vec4(0.5));
    highp ivec4 gathC6 = textureGather(CA6, vec4(0.5), 1);
    highp uvec4 gath7 = textureGather(CA7, vec4(0.5));
    highp uvec4 gathC7 = textureGather(CA7, vec4(0.5), 0);

    highp vec4 gath5 = textureGather(CA5, vec4(0.5), 2.5);

    highp ivec3 s1 = imageSize(CA1);
    highp ivec3 s2 = imageSize(CA2);
    highp ivec3 s3 = imageSize(CA3);
}
