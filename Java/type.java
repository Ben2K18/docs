byte
      8 bits
      -128 ~ 127
      -2^7 ~ 2^7-1
      default value 0
      byte a=100;
      byte b=-50;
      
short
      16 bit
      -2^15 ~ 2^15 -1
      -32768 ~ 32767
      default 0
      short a=1000;
      show b=-2000;
      
int
      32 bits
      -2,147,483,468 ~ 2,147,483,647 
      -2^31 ~ 2^31 - 1
      default 0
      int a=10000;
      
long  数据一定要在数值后面加上 L，否则将作为整型
      64 bits
      -9,223,372,036,854,775,808 ~ 9,223,372,036,854,775,807
      -2^63 ~ 2^63 - 1 
      default 0L
      long a=1000000L;
      long b=-2000000L;
      
float
      32 bits 754 floating point
      default 0.0f
      float f = 235.5f;
      
double
      64 bits IEEE 754 floating point
      default 0.0d
      double a = 123.4d;
      double b = 123.4;
      
boolean
      1 bit
      true | false
      default false
      boolean max = true;
      
char
      16 bits
      \u0000 ~ \uffff
      0 ~ 65535
      chart c = 'A';
