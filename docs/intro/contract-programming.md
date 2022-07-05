---
title: Contract Programming
parent: Introduction to D
nav_order: 10
---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Contract Programming

Contracts are a breakthrough technique to reduce the programming effort for large projects.
Contracts are the concept of preconditions, postconditions and errors.

## Preconditions/Postconditions

The pre contracts specify the preconditions before a statement is executed. The most typical use of this would be in validating the parameters to a function.
The post contracts validate the result of the statement.
The most typical use of this would be in validating the return value of a function and of any side effects it has.
In D, pre contracts begin with in, and post contracts begin with out.
They come at the end of the function signature and before the opening brace of the function body.

```d
int fun(ref int a, int b)
in (a > 0)
in (b >= 0, "b cannot be negative!")
out (r; r > 0, "return must be positive")
out (; a != 0)
{
    // function body
    return 0;
}

int fun(ref int a, int b)
in
{
    assert(a > 0);
    assert(b >= 0, "b cannot be negative!");
}
out (r)
{
    assert(r > 0, "return must be positive");
    assert(a != 0);
}
do
{
    // function body
    return 0;
}
```

The two functions are almost identical semantically.
The expressions in the first are lowered to contract blocks that look almost exactly like the second, except that a separate block is created for each expression in the first, thus avoiding shadowing variable names.

To test your knwoledge, answer this [quiz](./quiz/function-overloading.md)

### Practice

Navigate to the `practice/distribute-sum` directory.
Inspect the source file distribute.d and follow the instructions.

- Complete the `distribute` function.
- Write an `in` contract that ensures the value of the first argument(`sum`) is positive.
- Write an `out` contract that ensures the value of `sum` is equal to `first` + `second`.

## Invariants

Invariants are used to specify characteristics of a class or struct that must always be true (except while executing a member function).
For example, a class representing a date might have an invariant that the day must be `1..31` and the hour must be `0..23`:

```d
class Date
{
    int day;
    int hour;

    this(int d, int h)
    {
        day = d;
        hour = h;
    }

    invariant
    {
        assert(1 <= day && day <= 31);
        assert(0 <= hour && hour < 24, "hour out of bounds");
    }
}
```

For public or exported functions, the order of execution is:
1. preconditions
1. invariant
1. function body
1. invariant
1. postconditions

### Practice

Navigate to `practice/my-associative-array` directory.
Follow the directions in the skeleton in order to implement our very own `string : int` associative array.

For the purpose of this exercise and lab, we suggest implementing the associative array using vectors.
Feel free to go a little extra and make use of a linked list, hash functions, or whatever design of a hash map you prefer.
