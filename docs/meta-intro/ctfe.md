---
title: Compile time function execution (CTFE)
parent: Introduction to Meta-Programming
nav_order: 2
---

# Compile time function execution (CTFE)

CTFE is a mechanism which allows the compiler to execute functions at compile time.
There is no special set of the D language necessary to use this feature.
The only requirement is that the function just depends on values known at compile time.

Keywords like [static](https://dlang.org/spec/attribute.html#static), [ immutable](https://dlang.org/spec/attribute.html#immutable) or [enum](https://dlang.org/spec/enum.html#manifest_constants) instruct the compiler to use CTFE.

```d
int sum(int a, int b)
{
    return a + b;
}

void main()
{
    enum a = 5;
    enum b = 7;
    enum c = sum(a, b);
}
```

In the above example, `sum(a, b)` is evaluated at compile time.
In the object file, no call to `sum` is issued.

TODO: quiz
> :warning: If the type of `a` or `b` is changed to `int`, the compiler will issue an error. Why?

## Practice

Pragmas are compile time instructions used to pass or ask the compiler for specific information.
`pragma(msg)` is used as a compile time debugging tool that allows printing of compile time known variables:

```d
class Foo {}
Foo a;
enum b = 2;
pragma(msg, "hello");     // prints "hello" at compile time
pragma(msg, Foo);         // prints Foo at compile time
pragma(msg, a);           // error, a cannot be read at compile time
pragma(msg, typeof(a));   // prints Foo at compile time
pragma(msg, b);           // prints 2 at compile time
```

Use `pragma(msg)` inside the code snippet above to observe the output when compiling the code.
