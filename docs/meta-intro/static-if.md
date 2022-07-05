---
title: Static if
parent: Introduction to Meta-Programming
nav_order: 4
---

# Static If

`static if` is the compile time equivalent of the `if` statement.
Just like the `if` statement, `static if` takes a logical expression and evaluates it.
Unlike the `if` statement, `static if` is not about execution flow; rather, it determines whether a piece of code should be included in the program or not.
The logical expression must be evaluable at compile time.
If the logical expression evaluates to true, the code inside the static if gets compiled.
If the condition is false, the code is not included in the program as if it has never been written.
`static if` can appear at module scope or inside definitions of `struct`, `class`, `template`, etc.
Optionally, there may be else clauses as well.
Let's use `static if` with a simple template:

```d
enum Square;
enum Rectangle;

struct Parallelogram(T)
{
    int length;

    static if(is(T == Rectangle))
    {
        int width;
        this(int length, int width)
        {
            this.length = length;
            this.width = width;
        }
    }
    else
    {
        this(int length)
        {
            this.length = length;
        }
    }
}

void main()
{
    auto x = Parallelogram!(Rectangle)(2, 5);
    auto z = Parallelogram!(Square)(2);
}
```

For the two instantiations, the compiler will generate the following `struct` declarations:

```d
struct Parallelogram!Rectangle
{
    int length;
    int width;
    this(int length, int width)
    {
        this.length = length;
        this.width = width;
    }
}

struct Parallelogram!Square
{
    int length;
    this(int length)
    {
        this.length = length;
    }
}
```
