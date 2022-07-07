---
nav_order: 3
title: Function Attributes
---
# Function Attributes

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

In D, we can distinguish between three types of function attributes:

- Return type attributes (`auto`, `ref`, `auto ref`, `inout`)
- Behavioral attributes (`pure`, `nothrow`, `@nogc`)
- Code safety attributes (`@safe`, `@trusted`, `@system`)

## Return type attributes

These attributes are about the return types of the functions.

### `auto`

When a function is annotated with `auto`, its return type doesn't need to be specified because it is automatically inferred by the compiler from the return expression(s).
Let's take a look at the following example:

```d
auto func(int i)
{
    if (i < 0)
    {
        return i;      // returns 'int' here
    }

    return i * 1.5;    // returns 'double' here
}

void main()
{
    // The return type of the function is 'double'
    auto result = func(42);
    static assert(is (typeof(result) == double));
}
```

If the `auto` function has only one `return` expression, then the compiler will take the type of that expression as the return type of the function. 
If there are multiple `return` expressions, the return expression of the function will be the _common type_. 
In the example above, the common type of `int` and `double` is `double`, and that's because `double` can hold any `int` value, but others as well.


### `ref`

If we want to modify a parameter and that change to be visible in the caller, then that parameter should be marked as `ref`.

```d
void bump(ref int x) { ++x; }

unittest
{
    int x = 1;
    bump(x);
    assert(x == 2);
}
```

If a function expects a `ref` parameter, then the argument that is passed should be an `lvalue`, otherwise the code won't compile:
```d
bump(5) // Error! Cannot bind an rvalue to a ref parameter
```

The `ref` attribute can be also used for the return type of a function.
In that case, the return value of the function is an `lvalue` as well.

Let's add `ref` to `bump`.
```d
ref int bump(ref int x)
{
    return ++x;
}

unittest
{
    int x = 1;
    bump(bump(x)); // Two increments
    assert(x == 3);
}
``` 
The inner call to `bump` returns an `lvalue` that is then passed again to `bump` and it works because `bump` expects a `ref`.
Had the definition of `bump` looked like this:
```d
int bump(ref int x) { return ++x; }
```
the compiler would have thrown an error for the call `bump(bump(x))`.
That is because it would have been an attempt to bind an `rvalue` to a function that expects an `lvalue`, that is, a `ref`.


### `auto ref`

Similar to `auto`, the return type of an `auto ref` function is deduced by the compiler.
This is especially useful for templates like the one below:

```d
auto ref foo(string magic)()
{
   static if(magic == "use ref")
   {
     int* x = new int;
     return *x;
   }
   else
   {
     return 0;
   }
}

void main()
{
    foo!""(); // returns rvalue, i.e. 0
    foo!"use ref"(); // returns lvalue, i.e. x, a pointer
}
```

Each unique set of compile-time arguments will generate a different function.

### `inout`

The `inout` attribute can be used for both parameters and return types of functions.
It works like a template for `const`, `immutable`, and _mutable_.

It is not a surprise that this function can be called with the `string` `"hello"`.
```d
string parenthesized(string phrase)
{
    return '(' ~ phrase ~ ')';
}

writeln(parenthesized("hello"));
```

However, we might want to call it with a dynamic array, it the following way:
```d
char[] m;    // has mutable elements
m ~= "hello";
writeln(parenthesized(m));  // compilation ERROR

Error: function deneme.parenthesized (string phrase)
is not callable using argument types (char[]).
```
The same limitation applies to `const(char)[]` strings as well.

A solution might be to write some overloads for this function.
```d
char[] parenthesized(char[] phrase)
{
    return '(' ~ phrase ~ ')';
}

const(char)[] parenthesized(const(char)[] phrase)
{
    return '(' ~ phrase ~ ')';
}
```

However, this is not elegant at all, and it might be replaced with a template:
```d
T parenthesized(T)(T phrase)
{
    return '(' ~ phrase ~ ')';
}
```
Although this solution has fewer lines of code and is more readable, now we can say that the template is too flexible because it can be instantiated even with types like `int` or `double` and to be really correct we would have to add some template constraints.

The solution we are looking for here is `inout`.
```d
inout(char)[] parenthesized(inout(char)[] phrase)
{
    return '(' ~ phrase ~ ')';
}
```
The `inout` solution from above is very similar to the template solution, the only difference being that `inout` only deduces the mutability attribute of the parameter and transfers it to the return type.

> When the function is called with `char[]`, it gets compiled as if `inout` is not specified at all. On the other hand, when called with `immutable(char)[]` or `const(char)[]`, `inout` means `immutable` or `const`, respectively.

The following code illustrates this principle:
```d
char[] m;
writeln(typeof(parenthesized(m)).stringof);

const(char)[] c;
writeln(typeof(parenthesized(c)).stringof);

immutable(char)[] i;
writeln(typeof(parenthesized(i)).stringof);
```
It prints:
```d
char[]
const(char)[]
string
```
 
## Behavioral attributes

`pure`, `nothrow`, and `@nogc` are attributes that express the behaviour of a function.

### `pure`

A function can either return a value, or affect the global state of the program, or both.
A function that alters the global state of a program is a function that produces `side-effects`.

```d
int score;

void incrementScore(int points);
{
    score += points;
}

void main()
{
    incrementScore(10); // mutates a global variable, i.e. has side-effects
}
```

Pure functions are functions that cannot directly access global or static mutable states.
When added to a function, `pure` guarantees that that function won't access or modify any implicit state in the program.
Unlike other functional programming languages, D's `pure` functions allow the modification of the caller state through mutable parameters.

```d
int foo(int[] arr) pure
{
    arr[] += 1;
    return arr.length;
}
int[] a = [1, 2, 3];
foo(a);
assert(a == [2, 3, 4]);
```
A pure function accepting parameters with mutable indirections offers what is called `weak purity` because it can change the program state transitively through its parameters.

On the other hand, a `pure` function that has no parameter with mutable indirections is called `strongly pure` and fulfills the purity definition common to the traditional functional languages.
Weakly pure functions are useful as reusable building blocks for strongly pure functions.

To prevent mutation, D offers the `immutable` type qualifier.
If all of the parameters of a pure function are `immutable` or copied values without any indirections (e.g. `int`), the type system guarantees that the function produces no side effects.

```d
struct S
{
    double x;
}

int foo(immutable(int)[] arr, int num, S val) pure
{
    //arr[num] = 1; // compile error
    num = 2;        // has no side effect to the caller side
    val.x = 3.14;   // ditto
    return arr.length;
}
```

Strong purity implies that the function always returns the same value for the same input.
This is especially useful for optimizations and gives both the compiler and the programmer optimization opportunities.
Instead of calling multiple times a strongly pure function with the same set of arguments, the function can be called only once and its return value can be cached and used in other places thus avoiding the overhead of additional function calls.

When it comes to templates, `pure` is automatically inferred by the compiler from the generated code, though it can be added by hand by the developer.

```d
import std.stdio;

// This template is impure when N is 0 because writeln() accesses global state
void templ(size_t N)()
{
    static if (N == 0)
    {
        // Prints when N is 0
        writeln("zero");
    }
}

void bar() pure
{
    templ!0();    // compilation ERROR, cannot call impure function
}

void foo() pure
{
    templ!1();    // compiles
}

void main()
{
    bar();
    foo();
}
```

Similar to templates, the compiler infers if a function or delegate literal is pure. The same goes for `auto` functions.

### Practice

1. Navigate to `demo/pure`.

- Take a look at the code. Is the `mutate` function pure? 
- If yes, why? If no, why?
- Add `pure` to the function and see if the code compiles. Do you understand why it happens the way it happens?

### `nothrow`

The `nothrow` attribute guarantees that a function does not throw any exceptions.
But before looking into `nothrow`, let's talk a bit about exceptions.

#### Exceptions

In general, exceptions are used to validate potentially invalid user input. Once an exception is thrown, the stack will be unwound until the first matching exception handler is found.
```d
import std.file : FileException, readText;
import std.stdio : writeln;

void main()
{
    try
    {
        readText("dummyFile");
    }
    catch (FileException e)
    {
        writeln("Message:\n", e.msg);
        writeln("File: ", e.file);
        writeln("Line: ", e.line);
        writeln("Stack trace:\n", e.info);

        // Default formatting could be used too
        // writeln(e);
    }
    finally
    {
        writeln("This message will be printed regardless of whether an exception is thrown");
    }
}
```

In D, the exception hierarchy starts with `Throwable`.
         Throwable (not recommended to catch)
            ↗                           ↖
       Exception                         Error (not recommended to catch)
     ↗         ↖                                        ↗         ↖
FileException StringException (and others)          RangeError    ...

`Exception` and `Error` are inherited from `Throwable` and are more specific.
It is not recommended to catch objects of type `Error` and objects of types that are inherited from `Error`.
That is because they represent system errors that are usually fatal.

The catch blocks are matched in the order in which they are declared, so they must be ordered from the most specific exception types to the most general exception types.
Given, for example, that the Exception type is the most general, it should be specified at the last catch block, if this is really needed.

```d
try
{
    // operations about student records that may throw
}
catch (StudentIdDigitException exc)
{
    // an exception that is specifically about errors with
    // the digits of student ids
}
catch (StudentIdException exc)
{
    // a more general exception about student ids but not
    // necessarily about their digits

}
catch (StudentRecordException exc)
{
    // even more general exception about student records
}
catch (Exception exc)
{
    // the most general exception that may not be related
    // to student records
}
```

The `throw` keyword can be used to deliberately throw exceptions.

Returning to `nothrow`, it guarantees that a function does not emit any exception.

> What is meant here by "any exception" is "any exception that is defined under the Exception hierarchy." A `nothrow` function can still emit exceptions that are under the `Error` hierarchy, which represents irrecoverable error conditions that should preclude the program from continuing its execution.

```d
import std.stdio;

int add(int lhs, int rhs) nothrow
{
    writeln("adding");    //  compilation ERROR because writeln is not a `nothrow` function
    return lhs + rhs;
}

void main()
{
    add(1, 2);
}
```

As with purity, the compiler automatically infers whether a template, delegate, or anonymous function is `nothrow`.

### Practice

1. Navigate to `demo/nothrow/` and make that program compile _without_ removing `nothrow` or the `writeln` statement.
2. Take a look at this [code](https://github.com/dlang/phobos/blob/master/std/algorithm/searching.d#L267) from Phobos, the D standard library. Why is this function no marked as `nothrow`?

### `@nogc`

D is a garbage-collected language.
Many data structures and algorithms in most D programs take advantage of dynamic memory blocks that are managed by the garbage collector (GC).
Such memory blocks are reclaimed again by the GC by an algorithm called garbage collection.

Some commonly used D operations take advantage of the GC as well. For example, elements of arrays live on dynamic memory blocks:

```d
// A function that takes advantage of the GC indirectly
int[] append(int[] slice)
{
    slice ~= 42;
    return slice;
}
```

If the slice does not have sufficient capacity, the `~=` operator above allocates a new memory block from the GC.

Although the GC is a significant convenience for data structures and algorithms, memory allocation and garbage collection are costly operations that make the execution of some programs noticeably slow.

`@nogc` means that a function cannot use the GC directly or indirectly:

```d
void foo() @nogc
{
    // ...
}
```

The compiler guarantees that a `@nogc` function does not involve GC operations.
For example, the following function cannot call `append()` because it does not provide the @nogc guarantee:
```d
void foo() @nogc
{
    int[] slice;
    // ...
    append(slice); // compilation ERROR - @nogc function 'foo' cannot call non-@nogc function 'append'
}
```

For an extensive list of operations forbidden in `@nogc` code, check this [link](https://dlang.org/spec/function.html#nogc-functions)

### Practice

1. Navigate to `demo/nogc`. Add `@nogc` to the `main` function and then make the required changes to the program so as to make it compile.

## Code safety attributes

As you might already imagine, `@safe`, `@trusted`, and `@system` are attributes that say something about the code safety that a function provides.
As with purity, the compiler infers the safety level of templates, delegates, anonymous functions, and `auto` functions.

### `@safe`

A `@safe` function is a function that is statically verified by the compiler to ensure that there are no operations that might lead to memory corruption.
In a `@safe` function, there are several language features that cannot be used, such as casts that break the type system or pointer arithmetic.
A full list of operations that are forbidden in `@safe` functions can be found [here](https://dlang.org/spec/function.html#safe-functions).
In spite of these limitations, these functions provide strong safety guarantees that are very important.

Let's take a look at this unsafe code from below:

```d
import std.stdio : writeln;

void main()
{
    int a = 7;
    int b = 9;

    /* some code later */

    *(&a + 1) = 2;
    writeln(b);
    writeln(b);
}
```

Running this code yields the result:

```
9
2
```

Wait, what?
No, this is not a typo: the value of b changes between two instructions for no apparent reason.
This is happening because the compiler does not offer any guarantees when it comes to pointer arithmetic on local variables.
Pointer arithmetic is by definition an unsafe operation and if the faulting line would have been hidden between another 1K lines of code, it would have taken a lot of time to get to the root of the problem.

Now let us annotate the main function definition with `@safe`:
```d
void main() @safe
```
The compiler correctly highlights:
```d
test.d(10): Error: cannot take the address of local var in @safe function main
```

### Practice

1. Navigate to the `demo/safe` directory. Inspect the source file. Compile and run the code.

- What does the code do? Why is it useful to take the address of a parameter?
- Add the `@safe` attribute to the `main` function. What happens?
- Add `@safe` to the `func` and `gun` functions. Analyze the error messages.
- How can we get rid of the first error message?
- What about the second error message?

2. Navigate to the `demo/code-safety` directory. Inspect the source file. Compile and run the code.

- Add `@safe` to the main function and then make the code compile by solving the issues.

### `@trusted`

A `@trusted` function provides the same guarantees as a `@safe` function, but it is assumed that the checks were done manually by the programmer.
That is because sometimes, even though the `@safe`ty rules work well to prevent memory corruption, they prevent a lot of valid, and actually safe code.
For example, consider a function that wants to use the system call `read`, which is prototyped like this:
```d
ssize_t read(int fd, void* ptr, size_t nBytes);
```

For those unfamiliar with this function, it reads data from the given file descriptor, and puts it into the buffer pointed at by `ptr` that is expected to be `nBytes` bytes long.
The function returns the number of bytes actually read, or a negative value if an error occurs.
However, this C idiom of passing the buffer and length separately is not a safe pattern because it's easy to pass a length that exceeds the buffer llength.
```c
char *buf = malloc(128);
auto nread = read(fd, buf.ptr, 10000);
```
This is clearly an unsafe pattern, so in D it is not possible to mark this code as `@safe`.

To solve this situation, D provides the `@trusted` attribute, which tells the compiler that the code inside the function is assumed to be `@safe`, but will not be mechanically checked.
It's on you, the developer, to make sure the code is actually `@safe`.

A function that solves the problem might look like this in D:
```d
auto safeRead(int fd, ubyte[] buf) @trusted
{
    return read(fd, buf.ptr, buf.length);
}
```

Before marking an entire function with `@trusted`, consider first if calling it from a given context would compromise the memory safety of the program.
If this is the case, this function should not be marked `@trusted` under any circumstances.
Even if the intention is to only call it in safe ways, the compiler will not prevent unsafe usage by others.
In our case, `safeRead` should be fine to call from any `@safe` context, so it's a great candidate for the `@trusted` attribute.

### Practice

1. Navigate to the `demo/trusted` directory. Inspect the source file. Compile and run the code.

- Is this code safe? Why?
- Apply `@safe` to the main function. What happens? Why?
- Move the `read` line in a new function, `safeRead`, that will be marked as `@trusted`.

2. Navigate to the `demo/template-inference` directory. Inspect the source file. Compile and run the code.

- Add the `@safe` attribute to the main function.
- How do you explain the result? 
- Why isn't the compiler complaining for the second invocation of func?

### `@system`

`@system` is the default safety attribute for functions and it implies that no automatic safety checks are performed.

### Practice

1. Navigate to `demo/all-attributes`. Edit the code so as to compile.

## Acknowledgement

The text of this lab was inspired by the books "Programming in D" by Ali Çehreli and "The D Programming Language" by Andrei Alexandrescu.
