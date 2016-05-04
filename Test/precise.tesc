#version 450
#extension GL_EXT_tessellation_shader : require
#extension GL_EXT_gpu_shader5 : require

float minimal() {
  precise float result = 5.0;
  float a = 10.0;
  float b = 20.0;
  float c = 30.0;
  float d = 40.0;
  result = a * b + c * d; //  c * d, a * b and rvalue1 + rvalue2 should be 'noContraction'.
  return result;
}

void continuous_assignment() {
  precise float result = 5.0;
  int a = 10;
  int b = 20;
  result = a = b + 4; // b + 4 should be 'noContraction'.
}

void convert() {
  precise float result;
  int a = 10;
  int b = 20;
  b = a + b; //  a + b should be 'noContraction'.
  result  = float(b); // convert operation should not be 'noContraction'.
}

float loop_for() {
  precise float r1 = 5.0;
  precise float r2 = 10.0;
  int a = 10;
  int b = 20;
  int c = 30;
  for (int i = 0; i < a; i++) {
    r1 += 3.12 + b + i; // 'noContration', this make i++ also 'noContraction'
    c += 1; // 'noContration'
  }
  a += 1; // a + 1 should not be 'noContraction'.
  r2 = c; // The calculation of c should be 'noContration'.
  return float(r1 + r2); // conversion should not be 'noContration'.
}

void loop_array(void) {
  precise int result = 5;

  int x = 22;
  int y = 33;

  int a0[3];
  result += x + y; // x + y should be 'noContraction' also result + rvalue.

  for (int i = 0; i < 3; ++i) {
    // a's dereference + 2 should be 'noContraction'.
    result += a0[i] + 2;
    // result + 1 and 3 - rvalue should be 'noContraction'.
    a0[i] = 3 - result++;
  }
}

void loop_while() {
  precise float result = 5.0;
  int a = 10;
  int b = 20;
  while (result < 10) {
    result += 3.12 + b; // result + 3.12 should be 'noContraction'.
  }
  result = a + b + 5; // b + 5 should be 'noCtraction' and also a + rvalue.
  result = 11.1;
}

float fma_not_decorated() {
    precise float result;
    float a = 1.0;
    float b = 2.0;
    float c = 3.0;
    b = b + c; // b + c should be decorated with 'noContraction'
    result = fma(a, b, c); // fma() should not be decorated with 'noContradtion'
    return result;
}

precise float precise_return_exp_func() {
  float a = 1.0;
  float b = 2.0;
  return a + b; // the ADD operation should be 'noContraction'
}

precise float precise_return_val_func() {
  float a = 1.0;
  float b = 2.0;
  float result = a + b; // the ADD operation should be 'noContraction'
  return result;
}

float precise_func_parameter(float b, precise out float c) {
  float a = 0.5;
  c = a + b; // noContration
  return a - b; // Not noContraction
}

void main(){}
