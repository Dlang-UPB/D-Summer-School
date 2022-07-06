---
title: Arrays
parent: Introduction to D
nav_order: 4
---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Arrays

The fundamental difference between a C array and a D array is that the former is represented by a simple pointer, while the latter is represented by a pointer and a size.
This design decision was taken because of the numerous cases of C buffer overflow attacks that can be simply mitigated by automatically checking the array bounds.
Let's take a simple example:

```c
#include <stdio.h>

void main()
{
    int a = 5;
    int b[10];
    b[11] = 9;
    printf("%d\n", a);
}
```

Compiling this code (without the stack protector activated) will lead to a buffer overflow in which the variable `a` will be modified and the print will output `9`.
Compiling the same code with D (simply replace the include with an `import std.stdio : printf`) will issue a compile time error that states that 11 is beyond the size of the array.
Aggregating the pointer of the array with its size facilitates a safer implementation of arrays.

D implements 2 types of arrays:
1. [Static Arrays](https://dlang.org/spec/arrays.html#static-arrays): their length must be known at compile time and therefore cannot be modified; all examples up until this point have been using static arrays.
1. [Dynamic Arrays](https://dlang.org/spec/arrays.html#dynamic-arrays): their length may change dynamically at run time.

## Slicing

Slicing an array means to specify a subarray of it.
An array slice does not copy the data, it is only another reference to it:

```d
void main()
{
    int[10] a;       // declare array of 10 ints
    int[] b;

    b = a[1..3];     // a[1..3] is a 2 element array consisting of a[1] and a[2]
    int x = b[1];    // equivalent to `int x = 0;`
    a[2] = 3;
    int y = b[1];    // equivalent to `int y = 3;`
}
```

## Array operations

### Array setting:

```d
void main()
{
    int[3] a = [1, 2, 3];
    int[3] c = [ 1, 2, 3, 4];  // error: mismatched sizes
    int[] b = [1, 2, 3, 4, 5];
    a = 3;                     // set all elements of a to 3
    a[] = 2;                   // same as `a = 3`; using an empty slice is the same as slicing the full array
    b = a[0 .. $];             // $ evaluates to the length of the array (in this case 10)
    b = a[];                   // semantically equivalent to the one above
    b = a[0 .. a.length];      // semantically equivalent to the one above
    b[] = a[];                 // semantically equivalent to the one above
    b[2 .. 4] = 4;             // same as b[2] = 4, b[3] = 4
    b[0 .. 4] = a[0 .. 4];     // error, a does not have 4 elements
    a[0 .. 3] = b;             // error, operands have different length
}
```

**.length** is a builtin array property.
For an extensive list of array properties click [here](https://dlang.org/spec/arrays.html#array-properties).

### Array Concatenation:

```d
void main()
{
    int[] a;
    int[] b = [1, 2, 3];
    int[] c = [4, 5];

    a = b ~ c;       // a will be [1, 2, 3, 4, 5]
    a = b;           // a refers to b
    a = b ~ c[0..0]; // a refers to a copy of b
    a ~= c;          // equivalent to a = a ~ c;
}
```

Concatenation always creates a copy of its operands, even if one of the operands is a 0-length array.
The operator `~=` does not always create a copy.

When adjusting the length of a dynamic array there are 2 possibilities:
1. The resized array would overwrite data, so in this case a copy of the array is created.
1. The resized array does not interfere with other data, so it is resized in place.
For more information click [here](https://dlang.org/spec/arrays.html#resize).

### Practice

Navigate to the `demo/slice` directory.
Inspect and run the file `slice.d`.
What happened here? Why?

Check you response by answering this [quiz](./quiz/slice.md).

### Vector operations:

```d
void main()
{
    int[] a = [1, 2, 3];
    int[] b;
    int[] c;

    b[] = a[] + 4;         // b = [5, 6, 7]
    c[] = (a[] + 1) * b[];  // c = [10, 18, 28]
}
```

Many array operations, also known as vector operations, can be expressed at a high level rather than as a loop.
A vector operation is indicated by the slice operator appearing as the left-hand side of an assignment or an op-assignment expression.
The right-hand side can be an expression consisting either of an array slice of the same length and type as the left-hand side or a scalar expression of the element type of the left-hand side, in any combination.

Using the concepts of slicing and concatenation, we can modify the original example (that does the removal of an element from the array) so that the `for` loop is no longer necessary:

```d
int main()
{
    int position = 7, c, n = 10;
    int[] array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    array = array[0 .. position] ~ array[position + 1 .. $];

    import std.stdio;
    writeln("Resultant array:");
    writeln(array);

    return 0;
}
```

[`writeln`](https://dlang.org/library/std/stdio/writeln.html) is a function from the standard D library that does not require a format and is easily usable with a plethora of types.

As you can see, the resulting code is much more expressive and fewer lines of code were utilized.

### Practice

Navigate to `practice/array-median` directory.
Open and inspect the file `arrayMedian.d`.
For this exercise, please add your solution inside the `medianElem` function.

Compute the [median element](https://www.geeksforgeeks.org/median/) of an unsorted integer array. For this, you will have to:
- Sort the array: implement any sorting algorithm you wish.
- Eliminate the duplicates: once the array is sorted, eliminating the duplicates is trivial.
- Check if the length of the array is **odd** or **even** and then return the [median element](https://www.geeksforgeeks.org/median/).

