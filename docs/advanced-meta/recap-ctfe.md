---
title: 'Recap: CTFE'
parent: Advanced Meta-Programming
nav_order: 2
---
# Recap: CTFE

We first introduced [Compile Time Function Evaluation](https://tour.dlang.org/tour/en/gems/compile-time-function-evaluation-ctfe) in [session 2](../meta-intro/ctfe.md).
It means precisely what its name implies: the compiler evaluates the result of a function whose parameters **are known at compile time**.
However, as we will see in this session, the compiler can also generate additional code, apart from executing it.

## `static` and `enum`

The keyword that is mostly associated with CTFE is `static`.
In [session 2](../meta-intro/static-if.md) you learnt about `static if`s.
They are conditions just like regular `if`s that are not verified at runtime, but at compile time.
This has the following advantages:
- running times are lower because the compiler now picks up some of the work
- they allow the compiler to make flexible and complex decisions about what code to compile and what code to ignore

However, these perks come at a cost: **all conditions must be evaluatable at compile time**.
This means that all values and types must be known by the compiler.
Therefore, for example, no user input or config file data can be used in a `static if`.

## Demo

Let's see what the `static` keyword is all about.
We'll use the code in `demo/ctfe/ctfe.d` for this.
The first `unittest` contains 2 `static assert`s.
The only difference from regular asserts is that the compiler verifies them when compiling with the flag `-unittest`, instead of us running the resulting executable.

Now look at the next `unittest` `if` statements inside the `unittest`.
Their body contains a `pragma(msg, ...)` statement, which prints a message to standard output at compile time.
Now compile and run the code if you haven't done so already.

[Quiz](./quiz/if-vs-static-if.md)

Remember that if the condition of a `static if` is not satisfied, **the compiler simply ignores whatever is inside it**...
Well, not entirely.
The body of the `static if` must still be syntactically correct, but not semantically correct.
Now it should be obvious that the compiler does not generate code for this `static if` body.
This is important for optimisations or for deciding what code to emit based on compile-time conditions.

## Practice

Uncomment the code in the last `unittest` and modify it so that the test passes.