#version 300 es

// this file cont\
ains no errors other than the #error which are there to see if line numbering for errors is correct

#error e1

float f\
oo;  // same as 'float foo;'

#error e2

#define MAIN void main() \
   {                     \
gl_Position = vec4(foo); \
} 

#error e3

MAIN

vec4 foo2(vec4 a)
{                                
  vec4 b = a;       \
  return b;                   
}

// aoeuntheo unatehutna \ antaehnathe 
// anteonuth $ natohe " '
// anteonuth     natohe

#define FOO int /* \
*/ goodDecl;

FOO

#define A int q1 = \ 1
#define B int q2 = \1
#define C int q3 = $ 1
#define D int q4 = @ 1

int a1 = \ 4;  // ERROR
int a2 = @ 3;  // ERROR
int a3 = $4;   // ERROR
int a4 = a2\;  // ERROR

A;
B;
C;
D;

# \

# \
    error good continuation

#define AA a \ b
