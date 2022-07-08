---
title: Manual vs. Automatic Memory Management and The Garbage Collector
parent: Memory Management
nav_order: 2
---

# Memory management in other systems programming languages

Now that we understand the necessity of dynamically allocated memory, let's compare manual and automatic ways of management.

C, which inspired the design of many of the languages that came after it, had no automatic memory management out of the box. You could make your own GC library or use a publicly available one, but it did not fit well with the design philosophy of the language: giving full responsability to the programmer, with minimal abstractions. C++ mostly followed in the footsteps of C in this regard, until C++11, when [smart pointers](https://docs.microsoft.com/en-us/cpp/cpp/smart-pointers-modern-cpp?view=msvc-170) were introduced, simplifying the use of dynamic memory. In contrast, Java has a complex automatic memory management system, based on a mark-and-sweep type of garbage collection (GC).

# The Garbage Collector

Ali Çehreli, in his Programming in D book, gives a good introduction to how the GC works at a high-level:

```
The dynamic variables that are used in D programs live on memory blocks that are owned by the garbage collector (GC). When the lifetime of a variable ends (i.e. it's no longer being used), that variable is subject to being finalized according to an algorithm that is executed by the GC. If nothing else needs the memory location containing the variable, the memory may be reclaimed to be used for other variables. This algorithm is called garbage collection and an execution of the algorithm is called a garbage collection cycle.
```

# Memory management in D

The [D language specification](https://dlang.org/spec/garbage.html) offers a good insight into how the D's GC works, here we will present only the most important aspects of it. D makes extensive use of GC, even if it might not be obvious at a first glance. To make efficient use of it, we must understand when and how the GC does it's job. Exceptions, strings, dynamic and associative arrays are some of the built-in types that make use of GC-allocated memory. Let's look at an example, using the append operator:

```d
void main() {
    int[] ints;
    foreach(i; 0..100) {
        ints ~= i;
    }
}
```

Appending elements to a dynamic array in this manner will trigger GC allocations when the capacity of the array is insufficient. You can see this by compiling the above code with the option ```-vgc```. Even better, we can use the [capacity](https://dlang.org/phobos/object.html#.capacity) property of the array to inspect the capacity at any time.

```d
void main() {
    import std.stdio : writef;
    int[] ints;
    size_t before, after, num;
    writef("%s", ints.capacity);
    foreach(i; 0..100) {
        before = ints.capacity;
        ints ~= i;
        after = ints.capacity;
        if(before != after) {
            writef(" -> %s", after);
            num++;
        }
    }
    writef("\nNumber of allocations: %s", num);
}
```

Now we can see exactly when the allocations take place. The output of the above snippet may look like this:
```
0 -> 3 -> 7 -> 11 -> 15 -> 23 -> 31 -> 43 -> 63 -> 91 -> 127
Number of allocations: 10
```

If we know exactly how much memory we need, we can preallocate it, triggering a single allocation:

```d
int[] ints = new int[](100);
```

# Using the Garbage Collector explicitly

To reclaim memory, the GC keeps track of which blocks of memory are still accessible and which are not. The GC starts from locations known as program roots (implicitly, those are: the stacks of every thread, all global and thread-local variables; you can add locations for the GC to scan for references to memory blocks with ```GC.addRoot``` or ```GC.addRange```) and looks for pointers to memory blocks. The GC will tag reachable blocks as still in use and unreachable blocks will be reclaimed. Because the GC allocated them in the first place, they are still accessible to the GC, so the GC can call their respective destructors.

GC algorithms may opt to move objects around in memory, to better use the available space, but this is costly, because every reference to those objects must also be moved to point to the new location. D's GC does not do this.

For more fine-tuned control over the GC, the ```core.memory``` module provides a few useful methods. We can disable the GC in critical sections of the program, where reclaiming memory might have a negative impact on the functionality:

```d
GC.disable();
// ... a part of the program where responsiveness is important ...
GC.enable();
```

Or we can trigger a collection cycle (deallocating unused memory) when we don't expect it to cause problems (for example, when our program is waiting for user input):

```d
import core.memory;
// ...
GC.collect(); // starts a garbage collection cycle
```

Explicit allocation can be done with ```GC.malloc```, ```GC.calloc```, ```GC.realloc```:

```d
// Allocate room for 25 ints
int * intBuffer = cast(int*)GC.calloc(int.sizeof * 25);
```

For classes, there is an important note to discuss: the size of a class variable is not the same as the size of a class object. ```.sizeof``` is the size of a class variable and is always the same value: 8 on 64-bit systems and 4 on 32-bit systems. The size of a class object must be obtained by ```__traits(classInstanceSize)```, like this:

```d
// Allocate room for 10 MyClass objects
MyClass * buffer = cast(MyClass*)GC.calloc(__traits(classInstanceSize, MyClass) * 10);
```

# @nogc

Previously discussed, the ```@nogc``` attribute will prevent any GC activity inside a method. This requires that any futher calls from a ```@nogc``` function be made to ```@nogc``` functions and prevents heap allocations for arrays, exceptions and so on. Below is a comprehensive list of restrictions for ```@nogc``` functions:

1. constructing an array on the heap
2. resizing an array by writing to its .length property
3. array concatenation
4. array appending
5. constructing an associative array
6. indexing an associative array (Note: because it may throw RangeError if the specified key is not present)
7. allocating an object with new on the heap
8. calling functions that are not @nogc, unless the call is in a ConditionalStatement controlled by a DebugCondition

```d
@nogc void foo()
{
    auto a = ['a'];    // (1) error, allocates
    a.length = 1;      // (2) error, array resizing allocates
    a = a ~ a;         // (3) error, arrays concatenation allocates
    a ~= 'c';          // (4) error, appending to arrays allocates

    auto aa = ["x":1]; // (5) error, allocates
    aa["abc"];         // (6) error, indexing may allocate and throws

    auto p = new int;  // (7) error, operator new allocates
    bar();             // (8) error, bar() may allocate
    debug bar();       // (8) Ok
}
void bar() { }
```
