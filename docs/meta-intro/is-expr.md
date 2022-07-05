---
title: is Expression
parent: Introduction to Meta-Programming
nav_order: 5
---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# is Expression

```d
is (/* ... */) // is expression
```

The is expression is evaluated at compile time.
It produces an `int` value, either `0` or `1` depending on the expression specified in parentheses.
Although the expression that it takes is not a logical expression, the is expression itself is used as a compile time logical expression.
It is especially useful in static if conditionals and template constraints.
The condition that it takes is always about types, which must be written in one of several syntaxes.

## 1. `is(T)`

The expression `is(T)` Determines whether `T` is a valid type.

```d
static if (is (int))     // passes
{
    writeln("valid");
} 

static if(is (asd))      // if asd is not a user defined type, the check will fail
{
    writeln("stop using such crippled names");
}
```

## 2. `is(T Alias)`

The `is(T Alias)` expression works in the same way as the previous syntax: it checks if `T` is a valid type.
Additionally, it defines `Alias` as an alias of `T`:

```d
static if (is (int NewAlias))
{
    writeln("valid");
    NewAlias var = 42; // int and NewAlias are the same
} 
else
{
    writeln("invalid");
}
```

## 3. `is(T : OtherT)`

The `is(T : OtherT)` expression determines whether `T` can automatically be converted to `OtherT`.
It is used to detect automatic type conversions:

```d
import std.stdio;
interface Clock
{
    void tellTime();
}
class AlarmClock : Clock
{
    override void tellTime()
    {
        writeln("10:00");
    }
}

void myFunction(T)(T parameter)
{
    static if (is (T : Clock))
    {
        // If we are here then T can be used as a Clock
        writeln("This is a Clock; we can tell the time");
        parameter.tellTime();
    }
    else
    {
        writeln("This is not a Clock");
    }
}
void main()
{
    auto var = new AlarmClock;
    myFunction(var);
    myFunction(42);
}
```

## 4. `is(T Alias : OtherT)`

The `is(T Alias : OtherT)` expression works in the same way as the previous syntax.
It checks is `T` can be implicitly converted to `OtherT` and it defines `Alias` as an alias of `T`.

## 5. `is(T == Specifier)`

The `is(T == Specifier)` expression determines whether `T` is the same type as `Specifier` or whether `T` matches that specifier.

When we change the previous example to use `==` instead of `:`, the condition would not be satisfied for `AlarmClock`:

```d
static if (is (T == Clock))
{
    writeln("This is a Clock; we can tell the time");
    parameter.tellTime();
}
else
{
    writeln("This is not a Clock");
}
```

Although `AlarmClock` is a `Clock` , it is not exactly the same type as `Clock`.
For that reason, now the condition is invalid for both `AlarmClock` and `int`.

These are the simplest uses of the is expression.
For an exhaustive guide to all the variations of is expression check this [link](https://dlang.org/spec/expression.html#is_expression).

### Practice

1. Inspect and compile the code snippet below.
What happens and why?
Solve the issue.

```d
T fun(T)(int a, T b)
{
    static if(is(typeof(A) : int))
        return b;
    else
        return a;
}

void main()
{
    fun(2, "hello");
    fun(2, 2.0);
}
```
