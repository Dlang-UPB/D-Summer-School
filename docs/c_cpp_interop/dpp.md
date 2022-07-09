---
title: DPP
parent: C\C++ Interoperability
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

### Practice

Write a D program for sorting an array  read from the stdin. For this task please use functions from stdlib to allocate the array and from stdio to print the sorted array.