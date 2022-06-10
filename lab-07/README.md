# C\C++ Interoperability and Tooling

## Interfacing to C

D is designed to fit comfortably with a C compiler for the target system. D makes up for not having its own VM by relying on the target environment's C runtime library. It would be senseless to attempt to port to D or write D wrappers for the vast array of C APIs available. How much easier it is to just call them directly.

### Calling C Functions from D

C functions can be called directly from D. There is no need for wrapper functions, argument swizzling, and the C functions do not need to be put into a separate DLL.

The C function must be declared and given a calling convention, most likely the "C" calling convention, for example:
```
extern (C) int strcmp(const char* string1, const char* string2);
```
and then it can be called within D code in the obvious way:
```
import std.string;
int myDfunction(char[] s)
{
    return strcmp(std.string.toStringz(s), "foo");
}
```

### Calling D Functions from C

For D functions to be able to be called from a C context, they should be annotated with the extern(C) attribute:
```
// test.d
extern (C) int average(int a, int b) { return (a+b)/2; }  
```
On the C side, the function signature must be provided:
```
// main.c
int average(int a, int b);
void main()
{
    int a = average(5, 9);
    printf("%d\n", a);     // prints 7;
}
```
Compilation of the sources is done in the following manner:
```
dmd -c test.d
gcc -o main.o -c main.c
gcc test.o main.o
```
Compiling the D and C code to object modules and then linking them into an executable is all that needs to be done. For this to work it is imperative that the label (the function name) is exactly the same on both D and C sides; also both sides need to respect the same calling convention. extern (C) instructs the compiler to mangle the name of the function according to the rules of the C languages; the D calling convention is the same as the C one.

### Structs and Unions

D structs and unions are analogous to C's. C code often adjusts the alignment and packing of struct members with a command line switch or with various implementation specific #pragmas. D supports explicit alignment attributes that correspond to the C compiler's rules. Check what alignment the C code is using, and explicitly set it for the D struct declaration. Example:
```
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

```
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
```
extern (C) __gshared int x;
```

## Interfacing to C++

Calling D functions from C++ and viceversa are achieved exactly the same as in the case of C, by using extern(C++).

### C++ namespaces

C++ symbols that reside in namespaces can be accessed from D. A namespace can be added to the extern (C++) linkage attribute:
```
extern (C++, N) int foo(int i, int j, int k);
 
void main()
{
    N.foo(1, 2, 3);   // foo is in C++ namespace 'N'
}
```

### Classes

C++ classes can be declared in D by using the extern (C++) attribute on class, struct and interface declarations. extern (C++) interfaces have the same restrictions as D interfaces, which means that Multiple Inheritance is supported to the extent that only one base class can have member fields.

extern (C++) structs do not support virtual functions but can be used to map C++ value types.

Unlike classes and interfaces with D linkage, extern (C++) classes and interfaces are not rooted in Object and cannot be used with typeid.

### Structs

C++ allows a struct to inherit from a base struct. This is done in D using alias this.
```
struct Base { ... members ... };

struct Derived
{
    Base base;       // make it the first field
    alias base this;

    ... members ...
}
```

### C++ Templates

C++ function and type templates can be bound by using the extern (C++) attribute on a function or type template declaration.

Note that all instantiations used in D code must be provided by linking to C++ object code or shared libraries containing the instantiations.

## BetterC

It is straightforward to link C functions and libraries into D programs. But linking D functions and libraries into C programs is not straightforward.

D programs generally require:

1. The D runtime library to be linked in, because many features of the core language require runtime library support.
2. The main() function to be written in D, to ensure that the required runtime library support is properly initialized.

To link D functions and libraries into C programs, it's necessary to only require the C runtime library to be linked in. This is accomplished by defining a subset of D that fits this requirement, called BetterC. BetterC is typically enabled by setting the -betterC command line flag for the implementation.

D features not available with BetterC:
- Garbage Collection
- TypeInfo and ModuleInfo
- Classes
- Built-in threading (e.g. core.thread)
- Dynamic arrays (though slices of static arrays work) and associative arrays
- Exceptions
- Synchronized and core.sync
- Static module constructors or destructors
- Vector Extensions

## Dub

DUB is the D language's official package manager, providing simple and configurable cross-platform builds. DUB can also generate VisualD and Mono-D package files for easy IDE support.

### Starting a new project
From your top-level source directory, run:
```
$ dub init myproject
```

This begins an interactive session:
```
Package recipe format (sdl/json) [json]:
Name [myproject]:
Description [A minimal D application.]: My first project
Author name [imadev]: My Name
License [proprietary]: Boost
Copyright string [Copyright © 2017, imadev]:
Add dependency (leave empty to skip) []:
Successfully created an empty project in '/home/imadev/src/myproject'.
Package successfully created in myproject
```

The following configuration file is generated:
```
{
	"name": "myproject",
	"authors": [
		"My Name"
	],
	"description": "My first project",
	"copyright": "Copyright © 2017, imadev",
	"license": "Boost"
}
```
You can execute `dub build` to build your project, `dub run` to build and run it, or `dub test` to build and run unit tests. The last line below is the output of the default application.

When you find a package to use from the DUB registry, add it to the dependency list in your DUB configuration file by running `dub add <packageName>`.

### Advanced usage
For more advanced feature, like single-file packages and managing local packages, please see [the advanced usage guide](https://dub.pm/advanced_usage.html).


## DPP

D was designed from the beginning to be ABI compatible with C. Translate the declarations from a C header file into a D module and you can link directly with the corresponding C library or object files. The same is true in the other direction as long as the functions in the D code are annotated with the appropriate linkage attribute. These days, it’s possible to bind with C++ and even Objective-C.

dpp is a compiler wrapper that will parse a D source file with the .dpp extension and expand in place any #include directives it encounters, translating all of the C or C++ symbols to D, and then pass the result to a D compiler (DMD by default). Example:

```
// stdlib.dpp
#include <stdio.h>
#include <stdlib.h>
 
void main() {
    printf("Hello world\n".ptr);
 
    enum numInts = 4;
    auto ints = cast(int*) malloc(int.sizeof * numInts);
    scope(exit) free(ints);
 
    foreach(int i; 0 .. numInts) {
        ints[i] = i;
        printf("ints[%d]: %d ".ptr, i, ints[i]);
    }
 
    printf("\n".ptr);
}
```

### Use DPP with dub

```
// Install dpp using dub
dub install dpp

// run main.dpp
dub run dpp -- main.dpp
```

## Exercises


### 1. C function interface

1. Write a D function that computes the average of an array of ints.
2. Write a main function in C that calls the function previously defined.
3. Compile the code. Does it work? Why?

### 2. Struct interface

1. Write a C function, called sumMembers that receives a parameter of type struct List3 that packs 3 integer values and computes the sum of the 3 members. Define struct Node and a main function that calls sumMembers.
2. Reimplement sumMembers in D by cut-pasting the original code. When linking the objects try using both gcc and dmd. What happens?
3. Redesign sumMembers by initializing a builtin array from the members and calling the library function [sum](https://dlang.org/phobos/std_algorithm_iteration.html#sum) on it. Before calling sum, manually add 5 and 6 to the array by using the concatenation equals operator ”~=”. When linking, try using both gcc and dmd. What happens? Why?
4. Compile the D code with betterC. What happens? Why?

### 3. C++ classes interface

Using the provided C++ stack implementation, write a D function that solves the valid parentheses problem. If you are not familiar with it, you can find the algorithm [here](https://www.educative.io/edpresso/the-valid-parentheses-problem)

### 4. DPP

Write a D program for sorting an array  read from the stdin. For this task please use functions from stdlib to allocate the array and from stdio to print the sorted array.
