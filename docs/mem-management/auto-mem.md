---
title: Automatic Memory Management
parent: Memory Management
nav_order: 4
---

# Automatic Memory Management in D

The [D language specification](https://dlang.org/spec/garbage.html) offers a good insight into how the D's GC works, here we will present only the most important aspects of it.
D makes extensive use of GC, even if it might not be obvious at a first glance.
To make efficient use of it, we must understand when and how the GC does it's job.
Exceptions, strings, dynamic and associative arrays are some of the built-in types that make use of GC-allocated memory.
Let's look at an example, using the append operator:

```d
void main() {
    int[] ints;
    foreach(i; 0..100) {
        ints ~= i;
    }
}
```

Appending elements to a dynamic array in this manner will trigger allocations when the capacity of the array is insufficient.
You can see this by compiling the above code with the option ```-vgc```.
Even better, we can use the [capacity](https://dlang.org/phobos/object.html#.capacity) property of the array to inspect the capacity at any time.
This is different from length:
- length is the number of elements currently stored in the array; this property can be read, but for dynamic arrays it can also be set (setting it might trigger an allocation)
- capacity (relevant only for dynamic arrays) is the maximum number of elements the array can hold before the array must be reallocated or extended

```d
void main() {
    import std.stdio : writef;

    int[] ints;
    writef("%s", ints.capacity);    // (1)

    size_t before, after, num;

    foreach(i; 0..100) {
        before = ints.capacity;
        ints ~= i;                  // (2)
        after = ints.capacity;

        if(before != after) {       // (3)
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

From line ```(1)``` we can see that when the dynamic array is uninitialized, it begins with capacity 0, meaning it will trigger an allocation the first time we try to append to it, at line ```(2)```.
Even if we appended only a single element, the capacity went from 0 to 3.
This makes sense, because it is acceptable to allocate slightly more space than we need, instead of requesting more memory every single time we append an element to the array.
Inside the loop, we continue to append until we have 3 elements and we want to append the 4th, and because we already reached our capacity of 3, we need to request more memory, and capacity is increased to 7, and so on.
The exact value the capacity will be set to after an allocation is implementation-dependent and could change between versions.

If we know exactly how much memory we need, a good strategy is to preallocate it, triggering a single allocation:

```d
int[] ints = new int[](100);
```

For objects in D, there is also ```.reserve```, which will, again, allocate only once:

```d
int[] ints;
ints.reserve(100);
```

Always keep in mind these good practices:
- loops, especially if they run many times, should be responsible only for arithmetic, as this is the quickest and most predictable type of computation; we should avoid as much as possible having conditionals inside loops (all modern CPUs implement branch prediction strategies, which can generate a lot of mispredictions inside loops), and even more so, memory allocations, in which your program requests memory from the operating system, which in turn allocates physical memory 
- preallocating memory gives multiple advantages: 1) you can allocate when you know the performance will have a minimal negative impact and 2) you can allocate fewer times, because you can plan how you are going to use the memory before you use it, something that no automated memory management system can do out of the box

## Practice

Starting from the code snippet below, define 3 methods, in which you do the same operation (say, append elements to an array), but use all the methods in the snippets above:
- declaration without initialization
- initialization with new
- reserve after declaration

The ```benchmark``` method takes a variable number of arguments (other methods) and calls each one a specified number of times, returning the total duration in an array.

```d
const int num_iterations = 2_000_000; // this will be the number of function calls
const int num_items = 100; // this will be the number of elements to append to the array

void array_declare() {
}

void array_new() {
}

void array_reserve() {
}

void main()
{
    import std.stdio : writeln, write;
    import std.datetime.stopwatch : benchmark;

    auto res = benchmark!(array_declare, array_new, array_reserve)(num_iterations);
    write("array_declare took "); writeln(res[0]);
    write("array_new took "); writeln(res[1]);
    write("array_reserve took "); writeln(res[2]);
}
```

Vary the number of iterations and items and interpret the results.
