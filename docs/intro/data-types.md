---
title: Data Types
parent: Introduction to D
nav_order: 3
---

# Data Types

The D programming language defines 3 classes of data types:

1. [Basic data types](https://dlang.org/spec/type.html#basic-data-types): such as `int`, `float`, `long` etc. that are similar to the ones provided by C;
1. [Derived data types](https://dlang.org/spec/type.html#derived-data-types): pointer, array, associative array, delegate, function;
1. [User defined types](https://dlang.org/spec/type.html#user-defined-types): class, struct, union, enum;

We will not insist on basic data types and pointers, as those are the same (or slightly modified versions) as the ones in C\C++.
We will focus on arrays, associative arrays, classes, structs and unions.
Delegates, functions and enums will be treated in a future lab.

Note that in D all types have a default value.
This means that there are no uninitialized variables.

```d
    int a; // equivalent to int a = 0;
    int *p; // equivalent to int *p = null;
    // The same goes for structs and classes: their fields are recursively initialised.
```
