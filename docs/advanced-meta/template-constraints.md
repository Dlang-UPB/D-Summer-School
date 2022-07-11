---
title: Template Constraints
parent: Advanced Meta-Programming
nav_order: 6
---
# Template Constraints

A template constraint is simply an `if` condition that comes before the function body.
Unlike template specialisations which only allow us to specify that a template type must inherit from some other type, template constraints come with the flexibility of `if` statements.
We can use complex expressions as constraints and we can combine them using `||` or `&&`.

## Demo

To understand template constraints better, let's look at the code in `demo/template-constraints/template_constraints.d`.
First, let's look at the `sub` function.
Its constraint (`if (is(T == int) || is(T == real) || is(T == double))`) checks whether the type of the arguments is `int`, `real` or `double`.
The `unittest` that calls this function specifies that `sub("yes", "no")` should not compile.

Now let's take a look at a more interesting example.
`returnIfPrimeTemplate` checks if its template argument is a prime number.
This means that `isPrime(num)` is evaluated at compile time.
This procedure is called [Compile Time Function Evaluation (CTFE)](https://tour.dlang.org/tour/en/gems/compile-time-function-evaluation-ctfe).
We will dive deeper into this topic [later in this session](./ctfe.md).
Until then, CTFE means precisely what its name implies: the compiler evaluates the result of a function whose parameters **are known at compile time**.

[Quiz 1](./quiz/template-constraints.md)

## Logger

While template specialisations work just fine for `bool` and `string` logs, they do not allow us to aggregate all numeric types into a signle function.

[Quiz 2](./quiz/template-specialisations.md)

What we need to be able to log numeric types is a [template constraint](https://dlang.org/concepts.html).

Now that you understand template constraints, find an appropriate [template trait](https://dlang.org/phobos/std_traits.html) and use it to create a log function for numeric data types.
You can convert them to strings using `std.conv.to`, as shown in the [section on UFCS](./log-simple-types.md#recap-ufcs).
