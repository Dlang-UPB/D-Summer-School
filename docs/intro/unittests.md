---
title: Unittests
parent: Introduction to D
nav_order: 9
---

# Unittests

Unit tests are a builtin framework of test cases applied to a module to determine if it is working properly.
A D program can be run with unit tests enabled or disabled.

Unit tests are a special function defined like:

```d
unittest
{
    // test code
}
```

Individual tests are specified in the unit test using [assert expressions](https://dlang.org/spec/expression.html#AssertExpression).
There can be any number of unit test functions in a module, including within struct and class declarations.
They are executed in lexical order.
Unit tests, when enabled, are run after all static initialization is complete and before the `main()` function is called.

```d
struct Sum
{
    int add(int x, int y) { return x + y; }

    unittest
    {
        Sum sum;
        assert(sum.add(3,4) == 7);
        assert(sum.add(-2,0) == -2);
    }
}
```

## Practice

Navigate to the `demo/binary-search` directory.
Inspect the source file binarySearch.d.
As the name implies, a binarySearch algorithm is implemented on integers.
Compile and run the file.

- Write a unittest function that tests some corner cases.
Are there any bugs in the algorithm implementation?
If so, fix them.
- Rewrite the binarySearch algorithm to make use of slices.

