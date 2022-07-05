---
title: Typeof
parent: Introduction to Meta-Programming
nav_order: 6
---

# Typeof

`typeof` is a way to specify a type based on the type of an expression.
For example:

```d
void func(int i)
{
    typeof(i) j;       // j is of type int
    typeof(3 + 6.0) x; // x is of type double
    typeof(1)* p;      // p is of type pointer to int
    int[typeof(p)] a;  // a is of type int[int*]

    writefln("%d", typeof('c').sizeof); // prints 1
    double c = cast(typeof(1.0))j; // cast j to double
}
```

The expression is not evaluated, just the type of it is generated:

```d
void func()
{
    int i = 1;
    typeof(++i) j; // j is declared to be an int, i is not incremented
    writefln("%d", i);  // prints 1
}
```
