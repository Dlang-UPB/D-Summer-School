---
nav_exclude: true
---
## Question Text

What is the output of the following code?
```d
import std.uni : toLower;

int fun(string s)
in (s == s.toLower())
{
    return -42;
}

string fun(int x)
out (; x >= 0)
{
    x *= -42;
    return "Hello World!";
}

void main()
{
    import std.stdio : writeln;

    writeln(fun("hello world!"));
    writeln(fun(-42));
}
```

## Question Answers

- Runtime error at 1st call of fun()
- Runtime error at 2nd call of fun()
- hello world!
-42
+ -42
Hello World!

## Feedback

The call `fun("hello world!")` will trigger our first function(that takes as input a string).
It respects the `in` contract so it will just  return -42.
The second call `fun(-42)` will trigger the second function.
At the end of the function the value of `x` will be **-42 * -42**, it respects the `out` contract, so it will return "Hello World!"
