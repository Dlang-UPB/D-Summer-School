---
title: Call toString when Defined 
parent: Improvements
nav_order: 1
---
# Call `toString` when Defined

What if a `struct` / `class` defines its own `toString` method?
Add the following method to the `Stats` struct and notice the difference in the log output.
Fix the `assert` in the `unittest`.
```d
string toString() const
{
    return "is " ~ (optional ? "" : "not ") ~ "optional, yields " ~
        souls.to!string ~ " souls";
}
```

Now add a `toString` method to the `Boss` struct.
Return whatever string you want from it.
Do not modify the `log` method yet.
Compile and run the code.

[Quiz](./quizzes/toString-log.md)

Change your code in the corresponding `log` function so that the log remains unchanged.
You can use a template trait: [`isFunction`](https://dlang.org/phobos/std_traits.html#isFunction).

Now make your `log` function call `toString` if it is defined.
Keep the previous functionality unchanged.
Use a `static if` and `__traits` to check if `toString` is defined.

## What if `toString` is not a function?

Now you've made your logging function call `toString` when it's available.
But what if `toString` is not a method?
What if it's a simple member variable?
Do you end up calling `obj.toString()` regardless?
If so, make sure you verify that `toString` is actually a function.
