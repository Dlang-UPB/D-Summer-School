---
title: Template Constraints
parent: Introduction to Meta-Programming
nav_order: 7
---

# Template Constraints

The fact that templates can be instantiated with any argument yet not every argument is compatible with every template brings an inconvenience.
If a template argument is not compatible with a particular template, the incompatibility is necessarily detected during the compilation of the template code for that argument.
As a result, the compilation error points at a line inside the template implementation:

```d
struct A
{
    int doSomething() { return 42; }
}

void fun(T)(T a)
{
    a.doSomething();    // <--- error here
}

void main()
{
    A a;
    int b;
    fun(a);
    fun(b);
}
```

Compiling this code will issue an error due to the fact that `int` does not have a method `doSomething`.
The error will be issued after the code for `fun!int` was generated, during the semantical analysis phase, at the call to `doSomething`.
Imagine that `fun` was defined in a library and the user does not have access to the source code; in this situation it is hard to spot the exact bug, however using template constraints eases this process:

```d
struct A
{
    int doSomething() { return 42; }
}

void fun(T)(T a)
if(is(typeof(a.doSomething)))    // <--- error here
{
    a.doSomething();
}

void main()
{
    A a;
    int b;
    fun(a);
}
```

Template constraints have the same syntax as an if statement (without else).

## Practice

1. Implement a generic partitioning search algorithm.
  * The algorithm will receive an array/associative array and an element and returns the number of elements that are lesser than the element in the array/associative array list of keys.
  * The element type may be struct, class or builtin type.
  * Use templated function(s) and `template constraints` or `static if`s to implement the various cases.
  * Use these [helper traits](https://dlang.org/phobos/std_traits.html).

2. Follow this [link](https://github.com/dlang/phobos/blob/master/std/algorithm/sorting.d#L317).
   That is the official D language standard library implementation of the `ordered` function.
   Read the documentation and the unittests, then try to understand the implementation.
   This is how real life meta-programming looks like.
   Ask the [lab rats](http://ocw.cs.pub.ro/courses/dss?&#team) about clarifications on any misunderstandings.
