---
title: BetterC
parent: C\C++ Interoperability
nav_order: 3
---

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

### Practice

1. Write a C function, called sumMembers that receives a parameter of type struct List3 that packs 3 integer values and computes the sum of the 3 members. Define struct Node and a main function that calls sumMembers.
2. Reimplement sumMembers in D by cut-pasting the original code. When linking the objects try using both gcc and dmd. What happens?
3. Redesign sumMembers by initializing a builtin array from the members and calling the library function [sum](https://dlang.org/phobos/std_algorithm_iteration.html#sum) on it. Before calling sum, manually add 5 and 6 to the array by using the concatenation equals operator ”~=”. When linking, try using both gcc and dmd. What happens? Why?
4. Compile the D code with betterC. What happens? Why?