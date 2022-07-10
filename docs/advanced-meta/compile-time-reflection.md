---
title: Compile Time Reflection
parent: Advanced Meta-Programming
nav_order: 7
---
# Compile Time Reflection

When logging numeric types, you used the [template traits](https://dlang.org/phobos/std_traits.html).
These traits are implemented in D's standard library.

In other cases however, library traits don't help.
There is no library template that can give us, for example, the name of a structure passed as a template or that gives us all the methods defined inside a class.
For such cases, we need something called **compile time reflection**.
It allows programs to obtain information that is available at compile time.
In our case, this information is the type with which the `log` function is instantiated and the members of that structure.
Compile time reflection uses the [`__traits`](https://dlang.org/spec/traits.html) keyword.

## Demo

Let's get more familiar with `__traits`.
Take a look at the code in `demo/compile-time-reflection/compile_time_reflection.d`.
Compile and run the code.

The first `unittest` displays a very common usage of `__traits`: to check certain properties of a given variable or type.
The second one showcases another usage: obtaining various type information.
In this case, we use it to access a given member of a structure or class, without knowing the specific type of that object.
This procedure is called [Duck Typing](https://en.wikipedia.org/wiki/Duck_typing).
It's defined by the saying "if it walks like a duck, and quacks like a duck, then it's a duck", meaning that the type of an object is unimportant, as long as it contains the methdos and fields we require.
We'll discuss this concept in more details [later in this session](./duck-typing.md).

## Logger

Now that you have a better grasp of `__traits`, head back to `logger/logger.d` and take another look at the `unittest` you added earlier.
To make it work, you first need to output the name of the structure.
Find the appropriate trait to obtain the name of the structure passed to the `log` function.
Use one of the traits listed in the [documentation](https://dlang.org/spec/traits.html).


Then, you need to iterate through all members of the structure. and print their names.
Now use another trait to obtain the list of all members of the structure.
Iterate this list using a `foreach` statement and append the name of each member of the structure to the output string.

[Quiz](./quiz/compile-time-reflection.md)
