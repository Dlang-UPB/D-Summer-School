---
title: Interfacing to C
parent: C\C++ Interoperability
nav_order: 1
---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Interfacing to C

D is designed to fit comfortably with a C compiler for the target system. D makes up for not having its own VM by relying on the target environment's C runtime library. It would be senseless to attempt to port to D or write D wrappers for the vast array of C APIs available. How much easier it is to just call them directly.

### Calling C Functions from D

C functions can be called directly from D. There is no need for wrapper functions, argument swizzling, and the C functions do not need to be put into a separate DLL.

The C function must be declared and given a calling convention, most likely the "C" calling convention, for example:
```
extern (C) int strcmp(const char* string1, const char* string2);
```
and then it can be called within D code in the obvious way:
```d
import std.string;
int myDfunction(char[] s)
{
    return strcmp(std.string.toStringz(s), "foo");
}
```

### Calling D Functions from C

For D functions to be able to be called from a C context, they should be annotated with the extern(C) attribute:
```d
// test.d
extern (C) int average(int a, int b) { return (a+b)/2; }  
```
On the C side, the function signature must be provided:
```c
// main.c
int average(int a, int b);
void main()
{
    int a = average(5, 9);
    printf("%d\n", a);     // prints 7;
}
```
Compilation of the sources is done in the following manner:
```sh
dmd -c test.d
gcc -o main.o -c main.c
gcc test.o main.o
```
Compiling the D and C code to object modules and then linking them into an executable is all that needs to be done. For this to work it is imperative that the label (the function name) is exactly the same on both D and C sides; also both sides need to respect the same calling convention. extern (C) instructs the compiler to mangle the name of the function according to the rules of the C languages; the D calling convention is the same as the C one.

### Structs and Unions

D structs and unions are analogous to C's. C code often adjusts the alignment and packing of struct members with a command line switch or with various implementation specific #pragmas. D supports explicit alignment attributes that correspond to the C compiler's rules. Check what alignment the C code is using, and explicitly set it for the D struct declaration. Example:
```d
// test.d
struct A                                                              
{                                                     
    int a;                                             
}                                                                     
 
extern(C) int fun(A a)                                 
{                                                     
    return a.a + 7;
}
```

```c
// main.c
#include <stdio.h>                                                                                           
struct A
{
    int a;
} a;
 
int fun(struct A a); 
 
void main()
{
    a.a = 6;
    printf("Called fun, response: %d\n", fun(a));
}
```
Both sides need to define the struct in order to know the layout in memory of the fields.

### Using existing C libraries

Since D can call C code directly, it can also call any C library functions, giving D access to the smorgasbord of existing C libraries. To do so, however, one needs to write a D interface (.di) file, which is a translation of the C .h header file for the C library into D.

For popular C libraries, the first place to look for the corresponding D interface file is the [Deimos Project](https://github.com/D-Programming-Deimos/). If it isn't there already, and you write one, please contribute it to the [Deimos Project](https://github.com/D-Programming-Deimos/).

### Accessing C globals

C globals can be accessed directly from D. C globals have the C naming convention, and so must be in an extern (C) block. Use the extern storage class to indicate that the global is allocated in the C code, not the D code. C globals default to being in global, not thread local, storage. To reference global storage from D, use the gshared storage class.
```d
extern (C) __gshared int x;
```

### Practice

1. Write a D function that computes the average of an array of ints.
2. Write a main function in C that calls the function previously defined.
3. Compile the code. Does it work? Why?