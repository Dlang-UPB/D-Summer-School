---
title: Interfacing to C++
parent: C\C++ Interoperability
nav_order: 2
---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Interfacing to C++

Calling D functions from C++ and viceversa are achieved exactly the same as in the case of C, by using extern(C++).

### C++ namespaces

C++ symbols that reside in namespaces can be accessed from D. A namespace can be added to the extern (C++) linkage attribute:
```d
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
```d
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

### Practice

Using the provided C++ stack implementation, write a D function that solves the valid parentheses problem. If you are not familiar with it, you can find the algorithm [here](https://www.educative.io/edpresso/the-valid-parentheses-problem)