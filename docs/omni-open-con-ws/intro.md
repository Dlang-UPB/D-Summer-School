---
nav_order: 9
title: OmniOpenCon Workshop
parent: OmniOpenCon Workshop
---

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# OmniOpenCon Workshop

## Write fast. Read fast. Run fast.

> "D is a multi-paradigm system programming language that combines a wide range of powerful programming concepts from the lowest to the highest levels.
> It emphasizes memory safety, program correctness, and pragmatism." - Ali Çehreli, Programming in D, 2018

## Intro to D

### Syntax

The D programming language uses a C-style syntax that ensures a smooth transition for programmers coming from a C\C++ background.
With no further ado, let us take a random C program and see what it takes to compile it with the D compiler:

```c
#include <stdio.h>

int main()
{
    int position = 7, c, n = 10;
    int array[n] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    for (c = position - 1; c < n - 1; c++)
        array[c] = array[c+1];

    printf("Resultant array:\n");
    for (c = 0; c < n - 1; c++)
        printf("%d\n", array[c]);

    return 0;
}
```

The code above simply deletes an element in an array.
Now let's take a look on what the minimum modifications are to make the code compile and run with D:

```d
import std.stdio;

int main()
{
    int position = 7, c, n = 10;
    int[10] array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    for (c = position - 1; c < n - 1; c++)
        array[c] = array[c+1];

    printf("Resultant array:\n");
    for (c = 0; c < n - 1; c++)
        printf("%d\n", array[c]);

    return 0;
}
```

As you can see, the only differences are:

- the `#include` directive was replaced by an `import` statement;
- the array definition and initialization are slightly modified;

> Most C programs require minimal changes in order to be compiled with the D compiler.
> So do not worry, even if you don't have any previous experience in D, you will be able to understand most of the programs written in it because the syntax is extremely similar to the C one.

### Imports

In D, `imports` represent the counterpart of the C `include` directive.
However there are 2 fundamental differences:

- Imports may selectively specify which symbols are to be imported. For example, in the above code snippet, the full standard IO module of the standard library is imported, even though only the `printf` function is used.
This results in a degradation in compile time since there is a larger symbol pool that needs to be examined when trying to resolve a symbol.
In order to fix this, we can replace the blunt import with:
```d
import std.stdio : printf;
```

- Imports may be used at any scope level.
```d
int main()
{
    int position = 7, c, n = 10;
    int[10] array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    for (c = position - 1; c < n - 1; c++)
        array[c] = array[c+1];

    // If the lines calling printf are deleted,
    // it is easier to spot the now useless import
    import std.stdio : printf;
    printf("Resultant array:\n");
    for (c = 0; c < n - 1; c++)
        printf("%d\n", array[c]);

    return 0;
}
```

### Data Types

The D programming language defines 3 classes of data types:

1. [Basic data types](https://dlang.org/spec/type.html#basic-data-types): such as `int`, `float`, `long` etc. that are similar to the ones provided by C;
1. [Derived data types](https://dlang.org/spec/type.html#derived-data-types): pointer, array, associative array, delegate, function;
1. [User defined types](https://dlang.org/spec/type.html#user-defined-types): class, struct, union, enum;

We will not insist on basic data types and pointers, as those are the same (or slightly modified versions) as the ones in C\C++.
We will focus on arrays, associative arrays, classes, structs and unions.
Delegates, functions and enums will be treated in a future lab.

Note that in D all types have a default value.
This means that there are no uninitialized variables.

```d
    int a; // equivalent to int a = 0;
    int *p; // equivalent to int *p = null;
    // The same goes for structs and classes: their fields are recursively initialised.
```

### Arrays

The fundamental difference between a C array and a D array is that the former is represented by a simple pointer, while the latter is represented by a pointer and a size.
This design decision was taken because of the numerous cases of C buffer overflow attacks that can be simply mitigated by automatically checking the array bounds.
Let's take a simple example:

```c
#include <stdio.h>

void main()
{
    int a = 5;
    int b[10];
    b[11] = 9;
    printf("%d\n", a);
}
```

Compiling this code (without the stack protector activated) will lead to a buffer overflow in which the variable `a` will be modified and the print will output `9`.
Compiling the same code with D (simply replace the include with an `import std.stdio : printf`) will issue a compile time error that states that 11 is beyond the size of the array.
Aggregating the pointer of the array with its size facilitates a safer implementation of arrays.

D implements 2 types of arrays:
1. [Static Arrays](https://dlang.org/spec/arrays.html#static-arrays): their length must be known at compile time and therefore cannot be modified; all examples up until this point have been using static arrays.
1. [Dynamic Arrays](https://dlang.org/spec/arrays.html#dynamic-arrays): their length may change dynamically at run time.

#### Slicing

Slicing an array means to specify a subarray of it.
An array slice does not copy the data, it is only another reference to it:

```d
void main()
{
    int[10] a;       // declare array of 10 ints
    int[] b;

    b = a[1..3];     // a[1..3] is a 2 element array consisting of a[1] and a[2]
    int x = b[1];    // equivalent to `int x = 0;`
    a[2] = 3;
    int y = b[1];    // equivalent to `int y = 3;`
}
```

#### Array setting

```d
void main()
{
    int[3] a = [1, 2, 3];
    int[3] c = [ 1, 2, 3, 4];  // error: mismatched sizes
    int[] b = [1, 2, 3, 4, 5];
    a = 3;                     // set all elements of a to 3
    a[] = 2;                   // same as `a = 3`; using an empty slice is the same as slicing the full array
    b = a[0 .. $];             // $ evaluates to the length of the array (in this case 10)
    b = a[];                   // semantically equivalent to the one above
    b = a[0 .. a.length];      // semantically equivalent to the one above
    b[] = a[];                 // semantically equivalent to the one above
    b[2 .. 4] = 4;             // same as b[2] = 4, b[3] = 4
    b[0 .. 4] = a[0 .. 4];     // error, a does not have 4 elements
    a[0 .. 3] = b;             // error, operands have different length
}
```

**.length** is a builtin array property.
For an extensive list of array properties click [here](https://dlang.org/spec/arrays.html#array-properties).

#### Array Concatenation

```d
void main()
{
    int[] a;
    int[] b = [1, 2, 3];
    int[] c = [4, 5];

    a = b ~ c;       // a will be [1, 2, 3, 4, 5]
    a = b;           // a refers to b
    a = b ~ c[0..0]; // a refers to a copy of b
    a ~= c;          // equivalent to a = a ~ c;
}
```

Concatenation always creates a copy of its operands, even if one of the operands is a 0-length array.
The operator `~=` does not always create a copy.

When adjusting the length of a dynamic array there are 2 possibilities:
1. The resized array would overwrite data, so in this case a copy of the array is created.
1. The resized array does not interfere with other data, so it is resized in place.
For more information click [here](https://dlang.org/spec/arrays.html#resize).

#### Vector operations

```d
void main()
{
    int[] a = [1, 2, 3];
    int[] b;
    int[] c;

    b[] = a[] + 4;         // b = [5, 6, 7]
    c[] = (a[] + 1) * b[];  // c = [10, 18, 28]
}
```

Many array operations, also known as vector operations, can be expressed at a high level rather than as a loop.
A vector operation is indicated by the slice operator appearing as the left-hand side of an assignment or an op-assignment expression.
The right-hand side can be an expression consisting either of an array slice of the same length and type as the left-hand side or a scalar expression of the element type of the left-hand side, in any combination.

Using the concepts of slicing and concatenation, we can modify the original example (that does the removal of an element from the array) so that the `for` loop is no longer necessary:

```d
int main()
{
    int position = 7, c, n = 10;
    int[] array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    array = array[0 .. position] ~ array[position + 1 .. $];

    import std.stdio;
    writeln("Resultant array:");
    writeln(array);

    return 0;
}
```

[`writeln`](https://dlang.org/library/std/stdio/writeln.html) is a function from the standard D library that does not require a format and is easily usable with a plethora of types.

As you can see, the resulting code is much more expressive and fewer lines of code were utilized.

### Associative Arrays (AA)

Associative arrays represent the D language hashtable implementation and have the following syntax:

```d
void main()
{
    // Associative array of ints that are indexed by string keys.
    // The KeyType is string.
    int[string] aa;

    // set value associated with key "hello" to 3
    aa["hello"] = 3;
    int value = aa["hello"];

    // remove the pair ("hello", 3)
    aa.remove("hello")
}
```

`remove(key)` does nothing if the given key does not exist and returns `false`.
If the given key does exist, it removes it from the AA and returns `true`.
All keys can be removed by using the method `clear`.

For more advanced operations on AAs check this [link](https://dlang.org/spec/hash-map.html#construction_assignment_entries).
For an exhaustive list of the AA properties check this [link](https://dlang.org/spec/hash-map.html#properties).

### Structs

In D, structs are simple aggregations of data and their associated operations on that data:

```d
struct Rectangle
{
    size_t length, width;
    int id;

    size_t area() { return length * width; }
    size_t perimeter() { return 2 * (length + width); }
    size_t isSquare() { return length == width; }
    void setId(int id) { this.id = id; }
}
```

### Classes

In D, classes are very similar with Java classes:

1. Classes can implement any number of interfaces
1. Classes can inherit a single class
1. Class objects are instantiated by reference only
1. super has the same meaning as in Java
1. overriding rules are very similar

The fundamental difference between **structs** and **classes** is that the former are **value** types, while the latter are **reference** types.
This means that whenever a struct is passed as an argument to an lvalue function parameter, the function will operate on a copy of the object.
When a class is passed as an argument to an lvalue function parameter, the function will receive a reference to the object.

Both **structs** and **classes** are covered more in depth in [Advanced Structs and Classes](../structs-classes/asc.md).

### Functions

Functions are declared the same as in C. In addition, D offers some convenience features like:

#### Uniform function call syntax (UFCS)

UFCS allows any call to a free function `fun(a)` to be written as a member function call: `a.fun()`

```d
import std.algorithm : group;
import std.range : chain, dropOne, front, retro;

//retro(chain([1, 2], [3, 4]));
//front(dropOne(group([1, 1, 2, 2, 2])));

[1, 2].chain([3, 4]).retro; // 4, 3, 2, 1
[1, 1, 2, 2, 2].group.dropOne.front; // (2, 3)

```

#### Overloading:

```d
import std.stdio : writefln;

void add(int a, int b)
{
    writefln("sum = %d", a + b);
}

void add(double a, double b)
{
    writefln("sum = %f", a + b);
}

void main()
{
    add(10, 2);
    add(5.3, 6.2);
}
```

Function overloading is a feature of object-oriented programming where two or more functions can have the same name but different parameters.
Overloading is done based on the **type of parameters**, not on the **return type**.

#### Default parameters:

```d
void fun(int a, int b=8) {}

void main()
{
    fun(7);    // calls fun(7, 8)
    fun(2, 3); // calls fun(2, 3)
}
```

A function may have any number of default parameters. If a default parameter is given, all following parameters must also have default values.

#### Auto return type:

```d
auto fun()
{
    return 7;
}

void main()
{
    int b = fun();
    auto c = fun();   // works for variables also
}
```

Auto functions have their return type inferred based on the type of the return statements.
Auto can be also used to infer the type of a variable declaration.

### Unittests

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

## Introduction to Meta-Programming

Let's delve into the basic concepts of meta-programming: compile time execution and templates.

### Manifest Constants

Manifest constants are variables evaluated at compile time.
They cannot change their value.
A manifest constant is declared by using the keywork **enum**:

```d
enum i = 4;      // i is 4 of type int
enum long l = 3; // l is 3 of type long
```

Manifest constants are not lvalues, meaning their address cannot be taken. They exist only in the memory of the compiler.
Declaring a manifest constant that cannot be evaluated at compile time is an error:

```d
void main()
{
    int a = 5;
    enum b = 5 + 2;   // ok, '5' and '2' are integer literals, known at compile time
    enum b = a + 2;   // error: 'a' cannot be read at compile time  
}
```

To make the above code work, **a** should be declared as an **enum**.

Manifest constants can be seen as compile time variable declarations.

### Compile time function execution (CTFE)

CTFE is a mechanism which allows the compiler to execute functions at compile time.
There is no special set of the D language necessary to use this feature.
The only requirement is that the function just depends on values known at compile time.

Keywords like [static](https://dlang.org/spec/attribute.html#static), [ immutable](https://dlang.org/spec/attribute.html#immutable) or [enum](https://dlang.org/spec/enum.html#manifest_constants) instruct the compiler to use CTFE.

```d
int sum(int a, int b)
{
    return a + b;
}

void main()
{
    enum a = 5;
    enum b = 7;
    enum c = sum(a, b);
}
```

In the above example, `sum(a, b)` is evaluated at compile time.
In the object file, no call to `sum` is issued.

#### Compile time prints

Pragmas are compile time instructions used to pass or ask the compiler for specific information.
`pragma(msg)` is used as a compile time debugging tool that allows printing of compile time known variables:

```d
class Foo {}
Foo a;
enum b = 2;
pragma(msg, "hello");     // prints "hello" at compile time
pragma(msg, Foo);         // prints Foo at compile time
pragma(msg, a);           // error, a cannot be read at compile time
pragma(msg, typeof(a));   // prints Foo at compile time
pragma(msg, b);           // prints 2 at compile time
```

Use `pragma(msg)` inside the code snippet above to observe the output when compiling the code.

### Templates

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

#### Function templates

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

#### Practice

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

#### More than one template parameter

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

#### Type deduction

The compiler's deciding on what type to use for a template parameter is called type deduction.

Continuing from the last example above, the compiler decides on the following types according to the two uses of the function template:
  * `int` and `wchar` when 42 is printed
  * `double` and `string` when 1.2 is printed

The compiler can deduce types only from the types of the parameter values that are passed to function templates.
Although the compiler can usually deduce the types without any ambiguity, there are times when the types must be specified explicitly by the programmer.

#### Explicit Type Specification

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

#### Template Instantiation

Automatic generation of code for a specific set of template parameter values is called an instantiation of that template for that specific set of parameter values.
For example, `to!string` and `to!int` are two different instantiations of the `to` function template.

#### Struct and Class templates

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

#### Default Template Parameters

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

### Static If

`static if` is the compile time equivalent of the `if` statement.
Just like the `if` statement, `static if` takes a logical expression and evaluates it.
Unlike the `if` statement, `static if` is not about execution flow; rather, it determines whether a piece of code should be included in the program or not.
The logical expression must be evaluable at compile time.
If the logical expression evaluates to true, the code inside the static if gets compiled.
If the condition is false, the code is not included in the program as if it has never been written.
`static if` can appear at module scope or inside definitions of `struct`, `class`, `template`, etc.
Optionally, there may be else clauses as well.
Let's use `static if` with a simple template:

```d
enum Square;
enum Rectangle;

struct Parallelogram(T)
{
    int length;

    static if(is(T == Rectangle))
    {
        int width;
        this(int length, int width)
        {
            this.length = length;
            this.width = width;
        }
    }
    else
    {
        this(int length)
        {
            this.length = length;
        }
    }
}

void main()
{
    auto x = Parallelogram!(Rectangle)(2, 5);
    auto z = Parallelogram!(Square)(2);
}
```

For the two instantiations, the compiler will generate the following `struct` declarations:

```d
struct Parallelogram!Rectangle
{
    int length;
    int width;
    this(int length, int width)
    {
        this.length = length;
        this.width = width;
    }
}

struct Parallelogram!Square
{
    int length;
    this(int length)
    {
        this.length = length;
    }
}
```


### is Expression

```d
is (/* ... */) // is expression
```

The is expression is evaluated at compile time.
It produces an `int` value, either `0` or `1` depending on the expression specified in parentheses.
Although the expression that it takes is not a logical expression, the is expression itself is used as a compile time logical expression.
It is especially useful in static if conditionals and template constraints.
The condition that it takes is always about types, which must be written in one of several syntaxes.

#### 1. `is(T)`

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

#### 2. `is(T Alias)`

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

#### 3. `is(T : OtherT)`

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

#### 4. `is(T Alias : OtherT)`

The `is(T Alias : OtherT)` expression works in the same way as the previous syntax.
It checks is `T` can be implicitly converted to `OtherT` and it defines `Alias` as an alias of `T`.

#### 5. `is(T == Specifier)`

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

### Typeof

`typeof` is a way to specify a type based on the type of an expression.
For example:

```d
void func(int i)
{
    typeof(i) j;       // j is of type int
    typeof(3 + 6.0) x; // x is of type double
    typeof(1)* p;      // p is of type pointer to int
    int[typeof(p)] a;  // a is of type int[int*]

    writefln("%d", typeof('c').sizeof); // prints 1
    double c = cast(typeof(1.0))j; // cast j to double
}
```

The expression is not evaluated, just the type of it is generated:

```d
void func()
{
    int i = 1;
    typeof(++i) j; // j is declared to be an int, i is not incremented
    writefln("%d", i);  // prints 1
}
```

### Template Constraints

The fact that templates can be instantiated with any argument yet not every argument is compatible with every template brings an inconvenience.
If a template argument is not compatible with a particular template, the incompatibility is necessarily detected during the compilation of the template code for that argument.
As a result, the compilation error points at a line inside the template implementation:

```d
struct A
{
    int doSomething() { return 42; }
}

void fun(T)(T a)
{
    a.doSomething();    // <--- error here
}

void main()
{
    A a;
    int b;
    fun(a);
    fun(b);
}
```

Compiling this code will issue an error due to the fact that `int` does not have a method `doSomething`.
The error will be issued after the code for `fun!int` was generated, during the semantical analysis phase, at the call to `doSomething`.
Imagine that `fun` was defined in a library and the user does not have access to the source code; in this situation it is hard to spot the exact bug, however using template constraints eases this process:

```d
struct A
{
    int doSomething() { return 42; }
}

void fun(T)(T a)
if(is(typeof(a.doSomething)))    // <--- error here
{
    a.doSomething();
}

void main()
{
    A a;
    int b;
    fun(a);
}
```

> Template constraints have the same syntax as an if statement (without else).