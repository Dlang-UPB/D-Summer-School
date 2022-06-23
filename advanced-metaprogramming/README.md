# Advanced Metaprogramming

> Inspired by [Bradley Chatha's](https://github.com/BradleyChatha) talk at [DConf 2021](https://www.youtube.com/watch?v=0lo-FOeWecA&list=PLIldXzSkPUXXA0Ephsge-DJEY8o7aZMsR&index=9).

In [session 2](../lab-02/) we introduced the concept of metaprogramming and explained its cornerstones: CTFE and templates.
While CTFE and templates are also found in other languages, such as C++, today we will dive deeper into metaprogramming and dicover more powerful features that are unique to D.

Metaprogramming means that a program is able to treat its own code as data.
This means that our code will analyse its data types and change its behaviour accordingly.
We will also write code that will then write itself.

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

## Recap: CTFE

We first introduced [Compile Time Function Evaluation](https://tour.dlang.org/tour/en/gems/compile-time-function-evaluation-ctfe) in [session 2](../lab-02/README.md#ctfe).
It means precisely what its name implies: the compiler evaluates the result of a function whose parameters **are known at compile time**.
However, as we will see in this session, the compiler can also generate additional code, apart from executing it.

### `static` and `enum`

The keyword that is mostly associated with CTFE is `static`.
In [session 2](../lab-02/README.md#static-if) you learnt about `static if`s.
They are conditions just like regular `if`s that are not verified at runtime, but at compile time.
This has the following advantages:
- running times are lower because the compiler now picks up some of the work
- they allow the compiler to make flexible and complex decisions about what code to compile and what code to ignore

However, these perks come at a cost: **all conditions must be evaluatable at compile time**.
This means that all values and types must be known by the compiler.
Therefore, for example, no user input or config file data can be used in a `static if`.

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
The body of the `static if` must still be sintactically correct, but not semantically correct.
Now it should be obvious that the compiler does not generate code for this `static if` body.
This is important for optimisations or for deciding what code to emit based on compile-time conditions.

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
Notice that the body of all these functions is identical.
We can use templates to "merge" these functions into a single one that handles all numeric types.

### Template Specialisations

We want all our `log` functions to use templates.
The signature of the function should look like this:
```d
string log(Data)(Data data, LogLevel level, string file = __FILE__)
```

But how will the compiler tell the `log` function for strings from the one for `bool`s, for example?
For this we need [template specialisations](https://dlang.org/spec/template.html#parameters_specialization).
They are created by adding `: <type>` after declaring a template type, like so:
```d
string log(Data : string)(Data str, LogLevel level, string file = __FILE__)
```

The compiler will use this template only when the logged data is a `string` or is of a type that inherits from `string`.
When multiple functions with the same name and different template specialisations are defined, the compiler chooses the most specialised template to instantiate.

### Template Constraints

While template specialisations work just fine for `bool` and `string` logs, they do not allow us to aggregate all numeric types into a signle function.

[Quiz](./quizzes/template-specialisations.md)

What we need to be able to log numeric types is a [template constraint](https://dlang.org/concepts.html).
A template constraint is simply an `if` condition that comes before the function body.
Unlike template specialisations which only allow us to specify that a template type must inherit from some other type, template constraints come with the flexibility of `if` statments.
We can use complex expressions as constraints and we can combine them using `||` or `&&`.

To understand template constraints better, let's look at the code in `demo/template-constraints/template_constraints.d`.
Compile and run the code.
First, let's look at the `sub` function.
Its constraint (`if (is(T == int) || is(T == real) || is(T == double))`) checks whether the type of the arguments is `int`, `real` or `double`.
The `unittest` that calls this function specifies that `sub("yes", "no")` should not compile.

Now let's take a look at a more interesting example.
`returnIfPrimeTemplate` checks if its template argument is a prime number.
This means that `isPrime(num)` is evaluated at compile time.
This procedure is called [Compile Time Function Evaluation (CTFE)](https://tour.dlang.org/tour/en/gems/compile-time-function-evaluation-ctfe).
We will dive deeper into this topic [later in this session](#ctfe).
Until then, CTFE means precisely what its name implies: the compiler evaluates the result of a function whose parameters **are known at compile time**.

[Quiz](./quizzes/template-constraints.md)

Now that you understand template constraints, find an appropriate [template trait](https://dlang.org/phobos/std_traits.html) and use it to create a log fuction for numeric data types.
You can convert them to strings using `std.conv.to`, as shown in the [section on UFCS](#recap-ufcs).

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
    assert("[warn] logger.d: Boss(Iudex Gundyr, 1, Stats(3000, false), )" == firstBoss.log(LogLevel.Warning));
}
```
Paste the unittest into your code and run it.
It wil probabily fail to compile.

### `__traits`

To make the above `unittest` work, you first need to output the name of the structure.
Then, you need to iterate through all members of the structure. and print their names.

When logging numeric types, you used the [template traits](https://dlang.org/phobos/std_traits.html).
These traits are implemented in D's standard library.

In our case, library traits don't help.
There is no library template that can give us, for example, the name of a structure passed as template.
For such cases, we need something called **compile time reflection**.
It allows programs to obtain information that is available at compile time.
In our case, this information is the type with which the `log` function is instantiated and the members of that structure.
Compile time reflection uses the [`__traits`](https://dlang.org/spec/traits.html) keyword.

Let's get more familiar with `__traits`.
Take a look at the code in `demo/compile-time-reflection/compile_time_reflection.d`.
Compile and run the code.

The first `unittest` displays a very common usage of `__traits`: to check certain properties of a given variable or type.
The second one showcases another usage: obtaining various type information.
In this case, we use it to access a given member of a structure or class, without knowing the specific type of that object.
This procedure is called [Duck Typing](https://en.wikipedia.org/wiki/Duck_typing).
It's defined by the saying "if it walks like a duck, and quacks like a duck, then it's a duck", meaning that the type of an object is unimportant, as long as it contains the methdos and fields we require.
We'll discuss this concept in more details [later in this ssession](#duck-typing).

Now that you have a better grasp of `__traits`, head back to `logger/logger.d` and find the appropriate trait to obtain the name of the structure passed to the `log` function.
Use one of the traits listed in the [documentation](https://dlang.org/spec/traits.html).

Now use another trait to obtain the list of all members of the structure.
Iterate this list using a `foreach` statement and append the name of each member of the structure to the output string.

[Quiz](./quizzes/compile-time-reflection.md)

### CTFE Returns

We can optimise the `foreach` loop we've just written at compile time and have the compiler handle the iteration.

Concretely, we will change the `foreach` loop to a `static foreach` loop.
This will make the compiler replace the loop with each separate step:
```d
// This code:
static foreach (i; [1, 2, 3])
{
    writeln(i);
}

// is equivalent to:
writeln(1);
writeln(2);
writeln(3);
```

If you run into an error saying that `declaration <some_variable> is already defined`, keep in mind that unlike `foreach`, `static foreach` does **not** create a new scope.
Read the 4th point from [here](https://dlang.org/spec/version.html#staticforeach) to fix this error.

At this point, with a pretty short code base, our logger is capable of logging neearly any type:
- basic types
- arrays
- structures and classes

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

[Quiz](./quizzes/toString-log.md)

Change your code in the corresponding `log` function so that the log remains unchanged.
You can use a template trait: [`isFunction`](https://dlang.org/phobos/std_traits.html#isFunction).

Now make your `log` function call `toString` if it is defined.
Keep the previous functionality unchanged.
Use a `static if` and `__traits` to check if `toString` is defined.

## Improvements

### What if `toString` is not a function?

Previously, you made your logging function [use `toString`](#accommodate-tostring) when it's available.
But what if `toString` is not a method?
What if it's a simple member variable?
Do you end up calling `obj.toString()` regardless?
If so, make sure you verify that `toString` is actually a function.

### String Mixins

Up to now, you've probably used `__traits(getMember, obj, member)` or some other `__traits` for obtaining `obj.member`.
While this approach is definitely correct, it is not so expressive.
We can use CTFE once more to make our code even more readable while maintaining the same functionality.

In addition to CTFE, we need another D construct which is evaluated at compile time: [string mixins](https://dlang.org/articles/mixin.html).
In essence, they allow us to write strings which are then compiled into D code.
With string mixins, we can write code that writes itself.

Look at the code in `demo/string-mixins/string_mixins.d`.
As always, compile and run it.
This time, the `unittest` fails.
Understand the code and fix the `unittest`.

[Quiz](./quizzes/string-mixins.md)

For our use case with the logger, we need something simpler.
Simply rewrite `__traits(getMember, obj, member)` using a string mixin.

## Extra Metaprogramming

### Duck Typing

In section [`__traits`](#traits), we introduced the concept of [Duck Typing](https://en.wikipedia.org/wiki/Duck_typing).
This concept is commonly used in dynamically typed languages, such as Python.
Despite being statically typed, D also supports this feature via templates.

Being something extra, for this task we'll move away from our logger.
Open the file `duck-typing/duck_typing.d` and compile the code.
Fix the error and defeat the final boss.

[Quiz](./quizzes/duck-typing.md)
