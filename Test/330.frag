#version 330

in vec4 inVar;
out vec4 outVar;

varying vec4 varyingVar;

void main()
{
    gl_FragColor = varyingVar;
    gl_FragData[1] = inVar;
}
