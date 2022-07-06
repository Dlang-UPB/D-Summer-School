---
title: Imports
parent: Introduction to D
nav_order: 2
---

# Imports

In D, `imports` represent the counterpart of the C `include` directive.
However there are 2 fundamental differences:

- Imports may selectively specify which symbols are to be imported. For example, in the above code snippet, the full standard IO module of the standard library is imported, even though only the `printf` function is used.
This results in a degradation in compile time since there is a larger symbol pool that needs to be examined when trying to resolve a symbol.
In order to fix this, we can replace the blunt import with:
```d
import std.stdio : printf;
```

- Imports may be used at any scope level.
```d
int main()
{
    int position = 7, c, n = 10;
    int[10] array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    for (c = position - 1; c < n - 1; c++)
        array[c] = array[c+1];

    // If the lines calling printf are deleted,
    // it is easier to spot the now useless import
    import std.stdio : printf;
    printf("Resultant array:\n");
    for (c = 0; c < n - 1; c++)
        printf("%d\n", array[c]);

    return 0;
}
```
