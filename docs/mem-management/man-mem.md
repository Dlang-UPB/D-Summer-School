---
title: Manual Memory Management
parent: Memory Management
nav_order: 3
---

# Memory management in other systems programming languages

Now that we understand the necessity of dynamically allocated memory, let's compare manual and automatic ways of management.

C, which inspired the design of many of the languages that came after it, had no automatic memory management out of the box.
You could make your own GC library or use a publicly available one, but it did not fit well with the design philosophy of the language: giving full responsability to the programmer, with minimal abstractions.
C++ mostly followed in the footsteps of C in this regard, until C++11, when [smart pointers](https://docs.microsoft.com/en-us/cpp/cpp/smart-pointers-modern-cpp?view=msvc-170) were introduced, simplifying the use of dynamic memory.
In contrast, Java has a complex automatic memory management system, based on a mark-and-sweep type of garbage collection (GC).

# Manual Memory Management in D

D has bindings to most of the C standard library functions (```<stdlib.h>```) and you can use them by importing ```core.stdc.stdlib```.
To see a list of bindings, you can visit [this page](https://dlang.org/phobos/core_stdc_stdlib.html).
Today, we will refer to ```malloc```, ```calloc```, ```realloc``` and ```free```.
An important thing to note is, by looking at the signature, all of the 4 mentioned functions share these attributes: ```nothrow @nogc @system```.
These functions work exactly like in C, meaning you are fully responsible for the way you use memory, and from the ```@nogc``` attribute we can conclude that any memory allocated with these functions is completely foreign to D's automatic memory management system.
D also has the notion of ```@safe``` functions, which have a long list of [restrictions](https://dlang.org/spec/function.html#safe-functions), to enforce safe memory usage.
Since one of these restrictions is calling any ```@system``` functions, using them is generally not recommended.

```d
import core.stdc.stdlib;
import std.stdio;

void main()
{
    enum totalInts = 10;

    int[totalInts] ints;
    writeln(ints[0]); // will print 0, because types in D have a default initializer, called .init, which for type int gives 0

    // Allocate memory for 10 ints
    int* intPtrMalloc = cast(int*)malloc(int.sizeof * totalInts);
    int* intPtrCalloc = cast(int*)calloc(int.sizeof, totalInts);

    writeln(intPtrMalloc[0]); // will print a 'random' integer, because it does not use the D-specific initialization

    free(intPtrMalloc); // free intPtrMalloc immediately
    // intPtrMalloc[0] = 1; // this will not raise a segmentation fault, but it still is an error to reference free'd memory

    scope(exit) free(intPtrCalloc); // free intPtrCalloc at the end of the function
    intPtrCalloc[0] = 1; // ok
    writeln(intPtrCalloc[0]); // will print 1
}
```

The advantage to managing the memory yourself is predictability: you allocate the memory, you free the memory, and you can do it when you expect it will not impact your application's performance.
If you write code for embedded or real-time devices, the added complexity of managing the memory yourself might be a needed compromise in order to fit your terget system's requirements.

If you manually manage the memory, the chances of memory leaks to happen are high, and debugging memory leaks is not trivial in real-life applications.

We can also use the standard C functions to allocate aggregate types: 

```d
struct Point { int x, y; }

Point* onePoint = cast(Point*)malloc(Point.sizeof);
writeln(*onePoint); // prints Point(random int, random int)

Point* secondPoint = new Point();
writeln(*secondPoint); // prints Point(0, 0)

Point* tenPoints = cast(Point*)malloc(Point.sizeof * 10);
```

However, if you want to use ```malloc```, for example, together with default initializers or a struct/class constructor, you need to use ```emplace```.
This method is parameterized with the type you want to initialize, and the first argument is a pointer to the allocated memory of the object of that type.
Additional arguments can be provided, matching one of the constructors for the object.

# Practice

1. Use ```malloc``` together with ```emplace```, [documented here](https://dlang.org/phobos/core_lifetime.html#.emplace), to allocate and initialize a struct and a class.
For each, define a no-arg constructor and a constructor with at least one argument.
Use this as a starting point:

Use the code from ```mallocEmplace.d```, in the practice folder.

2. Define destructors and use ```destroy``` to call the destructors, then free the memory.