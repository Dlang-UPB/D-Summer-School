---
title: Functions
parent: Introduction to D
nav_order: 8
---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Functions

Functions are declared the same as in C. In addition, D offers some convenience features like:

## Uniform function call syntax (UFCS)

UFCS allows any call to a free function `fun(a)` to be written as a member function call: `a.fun()`

```d
import std.algorithm : group;
import std.range : chain, dropOne, front, retro;

//retro(chain([1, 2], [3, 4]));
//front(dropOne(group([1, 1, 2, 2, 2])));

[1, 2].chain([3, 4]).retro; // 4, 3, 2, 1
[1, 1, 2, 2, 2].group.dropOne.front; // (2, 3)

```

### Practice

Let's go back to the `practice/array-median` directory.
This time we want to find the [median element](https://www.geeksforgeeks.org/median/) using functions from the [std.algorithm](https://dlang.org/phobos/std_algorithm.html) package.
Use UFCS for an increase in expressiveness.
Observe the increase in performance achieved by using functions from the standard library

## Overloading:

```d
import std.stdio : writefln;

void add(int a, int b)
{
    writefln("sum = %d", a + b);
}

void add(double a, double b)
{
    writefln("sum = %f", a + b);
}

void main()
{
    add(10, 2);
    add(5.3, 6.2);
}
```

Function overloading is a feature of object-oriented programming where two or more functions can have the same name but different parameters.
Overloading is done based on the **type of parameters**, not on the **return type**.

## Default parameters:

```d
void fun(int a, int b=8) {}

void main()
{
    fun(7);    // calls fun(7, 8)
    fun(2, 3); // calls fun(2, 3)
}
```

A function may have any number of default parameters. If a default parameter is given, all following parameters must also have default values.

## Auto return type:

```d
auto fun()
{
    return 7;
}

void main()
{
    int b = fun();
    auto c = fun();   // works for variables also
}
```

Auto functions have their return type inferred based on the type of the return statements.
Auto can be also used to infer the type of a variable declaration.

### Practice

Navigate to the `practice/voldemort` directory.
`Result` is a struct declared inside `fun`'s scope.
However we want to be able to use it in `main` as well.
Inspect the file.
Does it compile?
Why?
Fix the issue.

