---
title: CTFE Returns
parent: Advanced Meta-Programming
nav_order: 8
---
# CTFE Returns

Remember that CTFE makes the compiler execute some code itself.
We can specify that certain statements are to be evaluated by the compiler by adding the `static` keyword before other keywords such as `if`, `foreach` and `assert`.

## Logger

We can optimise the `foreach` loop we've just written at compile time and have the compiler handle the iteration.

Concretely, we will change the `foreach` loop to a `static foreach` loop.
This will make the compiler replace the loop with each separate step:
```d
// This code:
static foreach (i; [1, 2, 3])
{
    writeln(i);
}

// is equivalent to:
writeln(1);
writeln(2);
writeln(3);
```

If you run into an error saying that `declaration <some_variable> is already defined`, keep in mind that unlike `foreach`, `static foreach` does **not** create a new scope.
Read the 4th point from [here](https://dlang.org/spec/version.html#staticforeach) to fix this error.

At this point, with a pretty short code base, our logger is capable of logging neearly any type:
- basic types
- arrays
- structures and classes

Now imagine doing this in any other object-oriented language you know: C++, Java, Python etc.
Yes, D is **that** cool.
