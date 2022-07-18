---
title: The Garbage Collector
parent: Memory Management
nav_order: 5
---

# The Garbage Collector

Ali Çehreli, in his Programming in D book, gives a good introduction to how the GC works at a high-level:

```
The dynamic variables that are used in D programs live on memory blocks that are owned by the garbage collector (GC).
When the lifetime of a variable ends (i.e. it's no longer being used), that variable is subject to being finalized according to an algorithm that is executed by the GC.
If nothing else needs the memory location containing the variable, the memory may be reclaimed to be used for other variables.
This algorithm is called garbage collection and an execution of the algorithm is called a garbage collection cycle.
```

# Using the Garbage Collector explicitly

We have already seen the GC in action in the last section, as it is responsible for allocating, extending or reclaiming memory, only we did not use it explicitly.

Explicit allocation with the GC can be done with `GC.malloc`, `GC.calloc`, `GC.realloc`:

```d
// Allocate room for 25 ints
int* intBuffer = cast(int*) GC.calloc(int.sizeof * 25);
```

A key thing here is that `GC.malloc`, `GC.calloc`, `GC.realloc` are different from the `malloc`, `calloc`, `realloc` that we have seen in the manual management section.
The GC methods will allocate memory managed by the GC.
`GC.free` can be called to free the memory at any time, but it can also be left unfree'd, and the GC will reclaim it in a later collection cycle.

For classes, there is an important note to discuss: the size of a class variable is not the same as the size of a class object.
`.sizeof` is the size of a class variable and is always the same value: 8 on 64-bit systems and 4 on 32-bit systems.
That is because a class variable is a reference, a pointer to where the class instance resides in memory.
The size of a class object must be obtained by `__traits(classInstanceSize)`, like this:

```d
// Allocate room for 10 MyClass objects
MyClass * buffer = cast(MyClass*) GC.calloc(__traits(classInstanceSize, MyClass) * 10);
```

To reclaim memory, the GC keeps track of which blocks of memory are still accessible and which are not.
The GC starts from locations known as program roots (implicitly, those are: the stacks of every thread, all global and thread-local variables; you can add locations for the GC to scan for references to memory blocks with `GC.addRoot` or `GC.addRange`) and looks for pointers to memory blocks.
The GC will tag reachable blocks as still in use and unreachable blocks will be reclaimed.
Because the GC allocated them in the first place, they are still accessible to the GC, so the GC can call their respective destructors.

To understand how `GC.addRoot` works, keep in mind that a root is a pointer to a GC memory block, which, if added with `GC.addRoot`, will not be reclaimed by the GC until we call `GC.removeRoot` and a collection cycle goes by.
If a block referenced by a root contains pointers to other GC-managed blocks, those blocks will not be collected until the root is removed or the memory is otherwise discarded.

```d
// Typical C-style callback mechanism; the passed function
// is invoked with the user-supplied context pointer at a
// later point.
extern(C) void addCallback(void function(void*), void*);

// Allocate an object on the GC heap (this would usually be
// some application-specific context data).
auto context = new Object;

// Make sure that it is not collected even if it is no
// longer referenced from D code (stack, GC heap, …).
GC.addRoot(cast(void*)context);

// Also ensure that a moving collector does not relocate
// the object.
GC.setAttr(cast(void*)context, GC.BlkAttr.NO_MOVE);

// Now context can be safely passed to the C library.
addCallback(&myHandler, cast(void*)context);

extern(C) void myHandler(void* ctx)
{
    // Assuming that the callback is invoked only once, the
    // added root can be removed again now to allow the GC
    // to collect it later.
    GC.removeRoot(ctx);
    GC.clrAttr(ctx, GC.BlkAttr.NO_MOVE);

    auto context = cast(Object)ctx;
    // Use context here…
}
```

`GC.addRange` is similar, but it receives a range of memory allocated outside the GC-managed memory (could be allocated with `malloc` from the C standard library, for example) and is scanned by the GC for pointers to GC-managed blocks.
As Michael Parker put it in his [The GC Series](https://dlang.org/blog/the-gc-series/), in order for the GC to properly do its job, it needs to be informed of any non-GC memory that contains, or may potentially contain, references to memory from the GC heap.
An example for this could be a linked list whose nodes are allocated with `malloc`, which might contain references to classes allocated with `new`.

```d
// Allocate a piece of memory on the C heap.
enum size = 1_000;
auto rawMemory = core.stdc.stdlib.malloc(size);

// Add it as a GC range.
GC.addRange(rawMemory, size);

// Now, pointers to GC-managed memory stored in
// rawMemory will be recognized on collection.
```

GC algorithms may opt to move objects around in memory, to better use the available space, but this is costly, because every reference to those objects must also be moved to point to the new location.
D's GC does not do this.

For more fine-tuned control over the GC, the `core.memory` module provides a few other useful methods.
We can disable the GC in critical sections of the program, where reclaiming memory might have a negative impact on the functionality:

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

# @nogc

Previously discussed, the `@nogc` attribute will prevent any GC activity inside a method.
This requires that any futher calls from a `@nogc` function be made to `@nogc` functions and prevents heap allocations for arrays, exceptions and so on.
Below is a comprehensive list of restrictions for `@nogc` functions:

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

# Profiling and configuring the GC

When running a D binary (not when compiling!), we can specify GC-specific options on the command line with `--DRT-gcopt=key1:value1 key2:value2 ..`.
For example, to enable GC profiling, we would run a binary named `app` like so: `app "--DRT-gcopt=profile:1" arguments to app`.
The output may look like this:

```
Number of collections:  17086
        Total GC prep time:  15 milliseconds
        Total mark time:  497 milliseconds
        Total sweep time:  125 milliseconds
        Max Pause Time:  0 milliseconds
        Grand total GC time:  637 milliseconds
GC summary:    1 MB,17086 GC  637 ms, Pauses  512 ms <    0 ms
```

This way, we can specify different configuration options for the GC, like initial memory to reserve, number of threads used to search the memory blocks for memory to collect and so on. You can find all the options [here](https://dlang.org/spec/garbage.html#gc_config).

## Practice

1. Use the code from the last Practice, but this time split it in 3 separate files, putting the code of each method in `main()`, wrapped in a for-loop, like this:

```d
// file array_declare.d
const int num_iterations = 1_000_000;

void main()
{
    foreach (int i; 0..num_iterations) {
        // code from array_declare, which might look like this:
        // int[] a;
        // foreach (int j; 0..num_items) a ~= j;
    }
}
```

Do the same for the other 2 methods.
Compile each binary, then run them like this: `time ./array_declare --DRT-gcopt=profile:1`.
Compare the results, looking at the number of collections and total GC time.
Pass different options to the GC; play with `initReserve`, `minPoolSize`, `incPoolSize`, `parallel`.

2. The GC has 2 public structs available in the `core.memory` module, from which we can analyse the general state and performance of the GC while the program is running.
Look up the fields of the [`GC.Stats`](https://dlang.org/library/core/memory/gc.stats.html) and [`GC.ProfileStats`](https://dlang.org/library/core/memory/gc.profile_stats.html) structs.
Create a program which uses a combination of a few different data types and produces a large number of allocations and collections.
Monitor the state of the program by printing fields like `usedSize`, `numCollections` and `totalCollectionTime` (you can use a different thread for this, or print from the main thread at key points in the execution).
Start from the example in the practice folder for this session.
