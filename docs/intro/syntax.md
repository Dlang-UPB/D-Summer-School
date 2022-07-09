---
title: Syntax
parent: Introduction to D
nav_order: 1
---

# Syntax

The D programming language uses a C-style syntax that ensures a smooth transition for programmers coming from a C\C++ background.
With no further ado, let us take a random C program and see what it takes to compile it with the D compiler:

```c
#include <stdio.h>

int main()
{
    int position = 7, c, n = 10;
    int array[n] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    for (c = position - 1; c < n - 1; c++)
        array[c] = array[c+1];

    printf("Resultant array:\n");
    for (c = 0; c < n - 1; c++)
        printf("%d\n", array[c]);

    return 0;
}
```

The code above simply deletes an element in an array.
Now let's take a look on what the minimum modifications are to make the code compile and run with D:

```d
import std.stdio;

int main()
{
    int position = 7, c, n = 10;
    int[10] array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    for (c = position - 1; c < n - 1; c++)
        array[c] = array[c+1];

    printf("Resultant array:\n");
    for (c = 0; c < n - 1; c++)
        printf("%d\n", array[c]);

    return 0;
}
```

As you can see, the only differences are:

- the `#include` directive was replaced by an `import` statement;
- the array definition and initialization are slightly modified;

Most C programs require minimal changes in order to be compiled with the D compiler.
So do not worry, even if you don't have any previous experience in D, you will be able to understand most of the programs written in it because the syntax is extremely similar to the C one.

Now, using the above code snippet, let us delve into the D specific concepts.
