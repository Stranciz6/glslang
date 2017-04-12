float4 c4;
float4 t4;
float4 f4;
float t;
float f;

float4 vectorCond()
{
    return (c4 ? t4 : f4) +
           (c4 ? t  : f );
}

float4 PixelShaderFunction(float4 input) : COLOR0
{
    int a = 1 < 2 ? 3 < 4 ? 5 : 6 : 7;
    int b = 1 < 2 ? 3 > 4 ? 5 : 6 : 7;
    int c = 1 > 2 ? 3 > 4 ? 5 : 6 : 7;
    int d = 1 > 2 ? 3 < 4 ? 5 : 6 : 7;
    float4 ret = a * input + 
                 b * input +
                 c * input +
                 d * input;
    int e;
    e = a = b ? c = d : 10, b = a ? d = c : 11;
    float4 f;
    f = ret.x < input.y ? c * input : d * input;
    return e * ret + f + vectorCond();
}
