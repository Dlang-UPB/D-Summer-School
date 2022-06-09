---
title: Log Simple Types
parent: Advanced Meta-Programming
nav_order: 3
---
# Log Simple Types

We compile the code in `./logger/logger.d`, using the `-unittest` flag:
```
student@dss:~/.../lab-06/logger$ make
dmd -unittest logger.d
logger.d(24): Error: function `logger.log(string str, LogLevel level, string file)` is not callable using argument types `(string)`
logger.d(24):        too few arguments, expected `3`, got `1`
make: *** [Makefile:7: logger] Error 1
```

The error says the function call does not match the signature.
Fix this by using the `LogLevel` enum so that the code compiles and the unittest passes.
You can use a default value for the `file` parameter.
In D, you can use the `__FILE__` special variable to obtain the name of the file, just like in C. 

## Recap: UFCS

Remember [UFCS](../intro/functions.md#uniform-function-call-syntax-ufcs) from session 1.
UFCS stands for Uniform Function Call Syntax and allows us to call function `foo` either as `foo(a)` or as `a.foo()`.
This feature makes code far more expressive.
To see the difference, compare:
```d
to!string(value);
```
to
```d
value.to!string;
```
Functionality-wise, the two snippets are equivalent.
And yes, the parentheses are optional when calling a function without parameters.

Use UFCS when calling `std.conv.to` and the `log` functions you're implementing.

## Logger

Add `log` functions for:
- `bool`
- `int`
- `long`
- `float`
- `double`

**Hint:** Use `std.conv.to` to convert numeric types to strings.

Write unittests for the new `log` functions.
