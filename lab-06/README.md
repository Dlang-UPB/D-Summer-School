# Design by Introspection

> Inspired by [Bradley Chatha's](https://github.com/BradleyChatha) talk at [DConf 2021](https://www.youtube.com/watch?v=0lo-FOeWecA&list=PLIldXzSkPUXXA0Ephsge-DJEY8o7aZMsR&index=9).

Over the years, a few programming paradigms have been successful enough to enter the casual vocabulary of software engineers: procedural, imperative, object-oriented, functional, generic, declarative.
But there's a B-list, too, that includes paradigms such as logic, constraint-oriented, and symbolic.
The point is, there aren't very many of them altogether.

**Design by Introspection (DBI)** is a proposed programming paradigm that is at the same time explosively productive and firmly removed from any of the paradigms considered canon.
The tenets of Design by Introspection are:
1. **The rule of optionality:** Component primitives are almost entirely opt-in.
A given component is required to implement only a modicum of primitives, and all others are optional.
The component is free to implement any subset of the optional primitives.
1. **The rule of introspection:** A component user employs introspection on the component to implement its own functionality using the primitives offered by the component.
1. **The rule of elastic composition:** A component obtained by composing several other components offers capabilities in proportion with the capabilities offered by its individual components.

In short, Design by Introspection is like LEGO: it offers building blocks that you can combine to create powerful constructs.

## Logging

In large applications, logs are a very useful tool for debugging.
In addition, they provide a huge help for newcomers, allowing them to understand the inner working of the project faster.
Thirdly, logs are extremely valuable for security.
Because they provide information about the behaviour of an application, security engineers monitor them to detect malware, while hackers try to tamper with logs to cover their tracks.

In this session, you'll implement a simple logger.
Typically, logs must contain relevant information about their source such as:
- **When:** The timestamp of the logged event
- **Who:** The application or user name
- **Where:** The context of the event: module, file, line number etc.
- **What:** The type of activity (login error, I/O error etc.) and error category (info, debug, warning, error etc.)

To make our logger easier to `unittest`, we will skip the "volatile" attributes of logs, such as timestamp and line number.
Concretely, our logger will display a given message, together with the log level and file name.
Our goal today is to implement this logger by leveraging D's flexibility and strength in metaprogramming.

## Log Simple Types

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

### `log` Functions for the Other Types

Add `log` functions for:
- `bool`
- `int`
- `long`
- `float`
- `double`

**Hint:** Use `std.conv.to` to convert numeric types to strings.

Write unittests for the new `log` functions.

### Recap: UFCS

Rememeber [UFCS](../lab-01/README.md#functions) from session 1.
UFCS stands for Uniform Function Call Syntax and allows us to call function `foo` either as `foo(a)` or as `a.foo()`.
This feature allows more expressive code.
To feel the difference, compare:
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

### Template `log` Funcions

Up to now, our logger contains lots of functions: one for each type of data that we've logged so far.
On its own, this is not necessarily a bad thing.
A function should _do one thing and do it well_.
And our `log` functions abide by this rule.

However, this rule does not imply duplicate code.
Probably each `log` function that logs numerical data looks something like this:
```d
string log(<type> value, LogLevel level, string file = __FILE__)
{
    return makeHeader(level, file) ~ value.to!string;
}
```
So the body of all these functions is identical.
We can use templates to "merge" these functions into a single one that handles all numeric types.

#### Template Specialisations

For this, we need a **template specialisation**.
TODO: demo

## Log Arrays

Now our logger elegantly handles basic data types.
But what if we want to log an array?
We'd like to log an array the same way we would write it in code, like so:
```d
[1, 2, 3].log(LogLevel.Info) == "[info] logger.d: [1, 2, 3]"'
```

To do this, we need to add the metadata to the returned string and then iterate the elements of the array and add each element `.to!string` to the returned string.

Implement another `log` function whose template constraint enforces the logged data to be an array.
Use a [trait](https://dlang.org/phobos/std_traits.html).
To create the logged string efficiently, use an [`Appender`](https://dlang.org/library/std/array/appender.html#2).
As always, add a new `unittest` to verify the correctness of your newly implemneted `log` function.

## Log Structures and Classes

What if we want to log a structure?
Or worse, a structure with nested structure members?
Take a look at the `unittest` below:
```d
unittest
{
    struct Stats
    {
        long souls;
        bool optional;
    }

    struct Boss
    {
        string name;
        int number;
        Stats stats;
    }

    Boss firstBoss = Boss("Iudex Gundyr", 1, Stats(3000, false));
    assert("Boss(Iudex Gundyr, 1, Stats(3000, false)" == firstBoss.log());
}
```
Paste the unittest into your code and run it.
It wil probabily fail to compile.

To make it work, you need to iterate through all members of the `Boss` structure.

### `__traits`

Use [`__traits(allMembers)`](https://dlang.org/spec/traits.html#allMembers) to obtain a list of all members of a structure or class.
TODO: demo?

### CTFE and String Mixins

TODO: `static foreach`

Now imagine doing this in any other object-oriented language you know: C++, Java, Python etc.
Yes, D is **that** cool.

### Call `toString` when Defined

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

[**Quiz**](./quizzes/toString-log.md)

Change your code in the corresponding `log` function so that the log remains unchanged.

**Hint:** this time, use a template trait: [`isFunction`](https://dlang.org/phobos/std_traits.html#isFunction).

Now make your `log` function call `toString` if it is defined.
Keep the previous functionality unchanged.

**Hint:** use a `static if` and `__traits` to check if `toString` is defined.

## Improvements

### What if `toString` is not a function?

Previously, you made your logging function [use `toString`](#accommodate-tostring) when it's available.
Make sure you verify that `toString` is actually a function.

## Duck Typing
