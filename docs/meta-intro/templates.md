---
title: Templates
parent: Introduction to Meta-Programming
nav_order: 3
---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Templates

Templates are the feature that allows describing the code as a pattern, for the compiler to generate program code automatically.
Parts of the source code may be left to the compiler to be filled in until that part is actually used in the program.
Templates are very useful especially in libraries because they enable writing generic algorithms and data structures, instead of tying them to specific types.

To see the benefits of templates let's start with a function that prints values in parentheses:

```d
void printInParens(int value)
{
    writefln("(%s)", value);
}
```

Because the parameter is specified as `int`, that function can only be used with values of type `int`, or values that can automatically be converted to `int`.
For example, the compiler would not allow calling it with a `floating point` type.
Let's assume that the requirements of a program changes and that other types need to be printed in parentheses as well.
One of the solutions for this would be to take advantage of function overloading and provide overloads of the function for all of the types that the function is used with:

```d
// The function that already exists
void printInParens(int value)
{
    writefln("(%s)", value);
}

// Overloading the function for 'double'
void printInParens(double value)
{
    writefln("(%s)", value);
}
```

This solution does not scale well because this time the function cannot be used with e.g. real or any user-defined type.
Although it is possible to overload the function for other types, the cost of doing this may be prohibitive.
An important observation here is that regardless of the type of the parameter, the contents of the overloads would all be generically the same: a single **writefln()** expression.

Such genericity is common in algorithms and data structures.
For example, the binary search algorithm is independent of the type of the elements: it is about the specific steps and operations of the search.
Similarly, the linked list data structure is independent of the type of the elements: linked list is merely about how the elements are stored in the container, regardless of their type.
Templates are useful in such situations: once a piece of code is described as a template, the compiler generates overloads of the same code automatically according to the actual uses of that code in the program.

## Function templates

Defining a function as a template is leaving one or more of the types that it uses as unspecified, to be deduced later by the compiler.
The types that are being left unspecified are defined within the template parameter list, which comes between the name of the function and the function parameter list.
For that reason, function templates have two parameter lists: 1) the template parameter list and 2) the function parameter list.

```d
void printInParens(T)(T value)
{
    writefln("(%s)", value);
}
```

The `T` within the template parameter list above means that `T` can be any type.
Although `T` is an arbitrary name, it is an acronym for "type" and is very common in templates.
Since `T` represents any type, the templated definition of `printInParens()` above is sufficient to use it with almost every type, including the user-defined ones:

```d
import std.stdio : writefln;
void printInParens(T)(T value)
{
    writefln("(%s)", value);
}
void main()
{
    printInParens(42);    // with int
    printInParens(1.2);   // with double

    auto myValue = MyStruct();
    printInParens(myValue);   // with MyStruct
}

struct MyStruct
{
    string toString() const
    {
        return "hello";
    }
}
```

The compiler considers all of the uses of `printInParens()` in the program and generates code to support all those uses.
The program is then compiled as if the function has been overloaded explicitly for `int`, `double`, and `MyStruct`:

```d
/* Note: These functions are not part of the source code.
 * They are the equivalents of the functions that the compiler
 * would automatically generate.
 */
void printInParens(int value)
{
    writefln("(%s)", value);
}

void printInParens(double value)
{
    writefln("(%s)", value);
}

void printInParens(MyStruct value)
{
    writefln("(%s)", value);
}
```

The output of the program is produced by those different instantiations of the function template:

```d
(42)
(1.2)
(hello)
```

### Practice

Inspect the snippet below and try to understand what happens.
What does the code do?
How many instances of the `printArguments` function are created?

```d
void printArguments(T...)(T t)
{
    static if(T.length == 0)
        return;
    else
    {
        import std.stdio : writeln;
        writeln(t[0]);
        printArguments(t[1 .. $]);
    }
}

struct MyClass
{
    string toString() const
    {
         return "MyClass Type";
    }
}

void main()
{
    printArguments!(int, string, MyClass)(2, "aha", MyClass());
}

```

**Hint**: Use `pragma(msg)` to inspect the instantiation type(s).

### More than one template parameter

Let's change the function template to take the parentheses characters as well:

```d
void printInParens(T)(T value, char opening, char closing)
{
    writeln(opening, value, closing);
}
```

Now we can call the same function with different sets of parentheses:

```d
printInParens(42, '<', '>');
```

Although being able to specify the parentheses makes the function more usable, specifying the type of the parentheses as char makes it less flexible because it is not possible to call the function with characters of type `wchar` or `dchar`:
```d
printInParens(42, '→', '←');    // compilation error
```

One solution would be to specify the type of the parentheses as `dchar` but this would still be insufficient as this time the function could not be called e.g. with `string` or user-defined types.
Another solution is to leave the type of the parentheses to the compiler as well.
Defining an additional template parameter instead of the specific `char` is sufficient:

```d
void printInParens(T, ParensType)(T value, ParensType opening, ParensType closing)
{
    writeln(opening, value, closing);
}
```

The meaning of the new template parameter is similar to `T`'s: `ParensType` can be any type.
It is now possible to use many different types of parentheses.
The following are with `wchar` and `string`:

```d
printInParens(42, '→', '←');
printInParens(1.2, "-=", "=-");
```

Output:
```d
→42←
-=1.2=-
```

The flexibility of `printInParens()` has been increased, as it now works correctly for any combination of `T` and `ParensType` as long as those types are printable with `writeln()`.

### Type deduction

The compiler's deciding on what type to use for a template parameter is called type deduction.

Continuing from the last example above, the compiler decides on the following types according to the two uses of the function template:
  * `int` and `wchar` when 42 is printed
  * `double` and `string` when 1.2 is printed

The compiler can deduce types only from the types of the parameter values that are passed to function templates.
Although the compiler can usually deduce the types without any ambiguity, there are times when the types must be specified explicitly by the programmer.

### Explicit Type Specification

Sometimes it is not possible for the compiler to deduce the template parameters.
A situation that this can happen is when the types do not appear in the function parameter list.
When template parameters are not related to function parameters, the compiler cannot deduce the template parameter types.
To see an example of this, let's design a function that asks a question to the user, reads a value as a response, and returns that value.
Additionally, let's make this a function template so that it can be used to read any type of response:

```d
T getResponse(T)(string question)
{
    writef("%s (%s): ", question, T.stringof);
    T response;
    readf(" %s", &response);
    
    return response;
}
```

That function template would be very useful in programs to read different types of values from the input.
For example, to read some user information, we can imagine calling it as in the following line:
```d
getResponse("What is your age?");
```

Unfortunately, that call does not give the compiler any clue as to what the template parameter `T` should be.
What is known is that the question is passed to the function as a string, but the type of the return value cannot be deduced:
```d
Error: template deneme.getResponse(T) cannot deduce template function from argument types !()(string)
```

In such cases, the template parameters must be specified explicitly by the programmer.
Template parameters are specified in parentheses after an exclamation mark:
```d
getResponse!(int)("What is your age?");
```

### Template Instantiation

Automatic generation of code for a specific set of template parameter values is called an instantiation of that template for that specific set of parameter values.
For example, `to!string` and `to!int` are two different instantiations of the `to` function template.

## Struct and Class templates

Structs and classes can be defined as templates as well, by specifying a template parameter list after their names:

```d
class Stack(T)
{
private:
    T[] elements;
public:
    void push(T element)
    {
        elements ~= element;
    }
    void pop()
    {
        --elements.length;
    }
    T top()
    {
        return elements[$ - 1];
    }
    size_t length()
    {
        return elements.length;
    }
}

void main()
{
    auto stack = new Stack!double();
}
```

Since structs and classes are not functions, they cannot be called with parameters.
This makes it impossible for the compiler to deduce their template parameters.
The template parameter list must always be specified for struct and class templates.

## Default Template Parameters

Sometimes it is cumbersome to provide template parameter types every time a template is used, especially when that type is almost always a particular type.
For example, `getResponse()` may almost always be called for the int type in the program, and only in a few places for the double type.
It is possible to specify default types for template parameters, which are assumed when the types are not explicitly provided.
Default parameter types are specified after the `=` character:

```d
T getResponse(T = int)(string question)
{
// ...
}
// ...
    auto age = getResponse("What is your age?");
```

As no type has been specified when calling `getResponse()` above, `T` becomes the default type `int` and the call ends up being the equivalent of `getResponse!int()`.

Default template parameters can be specified for struct and class templates as well, but in their case the template parameter list must always be written even when empty:

```d
struct Stack(T = int)
{
// ...
}
// ...
    Stack!() stack;
```

> :warning: Every instantiation of a template for a given set of types is considered to be a distinct type.
> For example, `Stack!int` and `Stack!double` are separate types:
```d
Stack!int stack = Stack!double(0.25, 0.75); // ← compilation ERROR
```

TODO: Note-tip style
Templates are entirely a compile-time feature.
The instances of templates are generated by the compiler at compile time.
