---
nav_order: 7
title: Advanced Classes and Structs
---
# Advanced Classes and Structs

<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

As we've seen in the introductory lab, in D structs and classes are features that allow the user to define new types by combing existing, more fundamental data types.
Both structs and classes are _user-defined types_.
While the definition of a `struct` or of a `class` is called a type, variables of struct and class types are called objects.

## Structs

```d
struct TimeOfDay
{
    int hour;      // ← Not a variable; will become a part of
                   //   a struct variable used in the program.

    int minute;   // ← Not a variable; will become a part of
}

TimeOfDay bedTime;    // This object contains its own hour
                      // and minute member variables.
```

### `static` members

Sometimes it makes sense to have one or more member variables that are shared between all the objects of a `struct` type.
If this is needed, we can have a `static` member. Let's take a look at the following example:
```d
struct S
{
    int a;
    int b;

    static int objectsCreated;

    this(int a, int b)
    {
        this.a = a;
        this.b = b;
        objectsCreated++;
    }
}

void main()
{
    auto s1 = S(1, 2);
    auto s2 = S(100, 200);
    auto s3 = S(4, 5);

    assert(s1.objectsCreated == 3);
    assert(s2.objectsCreated == 3);
    assert(s3.objectsCreated == 3);

    // a `static` member is owned by the entire type, meaning that
    // an object it's not necessarly needed to access that member
    assert(S.objectsCreated == 3);
}
```

There is a single variable of each `static` member for each _thread_.
That single variable is shared by all of the objects of that struct in that thread.


### Constructor and Other Special Functions

Most of the concepts discussed in this subsection apply mostly to classes as well.
The differences will be explained in the section dedicated to classes.

#### Constructor

When the name of a type is used like a function, i.e. along with parantheses, it is actually the constructor of that type that gets called.
```d
auto sObj = SomeStruct(8, 30);    // struct object construction

struct SomeStruct
{
    int a;
    int b;
    int c;
}
```

When it comes to `struct`s, the compiler generates a constructor that assigns the parameter values to the members of the struct.
This automatic constructor would look like this:
```d
struct SomeStruct
{
    int a;
    int b;
    int c;

    /* The equivalent of the compiler-generated automatic
    * constructor (Note: This is only for demonstration; the
    * following constructor would not actually be called
    * when default-constructing the object as Test().) */
    this(in int a = int.init,
         in int b = int.init,
         in int c = int.init)
    {
        this.a = a;
        this.b = b;
        this.c = c;
        // Inside member functions, 'this' stands for "this object".
        // this.a means "the field 'a' of this object".
    }
}
```
What is important to understand from here is that the struct members that are not specified in the constructor call get initialized by the `.init` value of their respective types.
The list of the `.init` values for basic data types can be found [here](https://dlang.org/spec/type.html#basic-data-types).

However, when it comes to classes, the compiler does *not* generate such an automatic constructor.
```d
class ChessPiece
{
    dchar shape;
    size_t value;
}

void main()
{
    auto king = new ChessPiece('♔', 100);  // ← compilation ERROR
}
```
```d
Error: no constructor for ChessPiece.
```
In order to be able to create class objects using the same syntax, a constructor must be _explicitly_ defined.

Structs can have user-defined constructors as well.

```d
struct Duration
{
    int minute;

    this(int hour, int minute)
    {
        this.minute = hour * 60 + minute;
    }
}

auto d = Duration(3, 30);
```

##### User-defined constructor disables automatic constructor
Once we define a constructor for `Duration`, this no longer works:
```d
auto dd = Duration(12); // compilation error
```
This happens because the defined constructor does not take a single parameter and the compiler-generated constructor is disabled.
To make it work, a solution is to overload the existing constructor by providing another one that takes only one parameter.
```d
struct Duration
{
    int minute;

    this(int hour, int minute)
    {
        this.minute = hour * 60 + minute;
    }

    this(int minute)
    {
        this.minute = minute;
    }
}
```

Object construction without any parameter is still valid.
```d
auto d = Duration();    // compiles
```
This is because
> in D, the `.init` value of every type must be known at compile time. The value of `d` above is equal to the initial value of `Duration`.
```d
assert(d == Duration.init);
```

##### static opCall

It is possible, however, to use a parameterless `static opCall()` for constructing objects without providing any parameters.
This has no effect on the `.init` value of the type.
To make it work, the `static opCall` must create and return - as a constructor does - an object of that struct type:
```d
import std.stdio;

struct Test
{
    static Test opCall()
    {
        writeln("A Test object is being constructed.");
        Test test;
        return test;
    }
}

void main()
{
    auto test = Test();
}

```

##### First assignment to a member is construction
In a constructor, the first assignment of each member is considered construction, whereas the next ones are considered normal assignment operations.
This special behavior is necessary so that `immutable` and `const` members can in fact be constructed with values known only at run time.
Otherwise, this would not have been possbile be possible as it's not allowed to assign values to `immutable` or `const` variables.
```d
struct S
{
    int m;
    immutable int i;

    this(int m, int i)
    {
        this.m = m;     // ← construction
        this.m = 42;    // ← assignment (possible for mutable member)

        this.i = i;     // ← construction
        this.i = i;     // ← compilation ERROR
    }
}

void main()
{
    auto s = S(1, 2);
}
```

#### Destructor

The destructor is a method that is called when the lifetime of an object ends.
The automatic destructor generated by the compiler executes the destructors of all of the `struct` members in order.
(This is not the case for objects that are constructed with the `new` keyword as these objects live on the heap.)
The lifetime of an object ends when leaving the scope that it is defined in.
```d
if (aCondition)
{
    auto duration = Duration(7);
    // ...

} // ← The destructor is executed for 'duration'
  //   at this point
```
The destructor is executed automatically.

```d
struct S
{
    int* p;

    this(int i)
    {
        p = cast(int*) malloc(int.sizeof);
        *p = i;
    }

    ~this()
    {
        free(p);
    }
}
```

#### Copy constructor
Copy construction is creating a new object as a copy of an existing one.

```d
struct S
{
    int i;
    double d;
}

auto existingObject = S();
auto a = existingObject;    // copy construction
```

As for the construction and destructor, for copy construction the compiler generates an automatic copy constructor that in the example above executes the following steps:
1. Copy `a.i` from `existingObject.i`
2. Copy `a.d` from `existingObject.d`

However, sometimes the automatic copy constructor is not suitable for our needs.
Let's take a look at the following example:
```d
struct Student
{
    int number;
    int[] grades;
}

auto student1 = Student(1, [ 70, 90, 85 ]);

auto student2 = student1;    // copy construction
student2.number = 2;

student1.grades[0] += 5;     // this changes the grade of the
                             // second student as well:
assert(student2.grades[0] == 75);
```

To avoid such cases, a custom copy constructor must be defined by the user.

### Practice

Navigate to `demo/copyctor/`. Define a custom copy constructor to obtain the correct behaviour.

### Disabling member functions

Functions that are declared as `@disable` cannot be used.
For example, sometimes it is incorrect to have default values for the members of a type and you want to prevent this behaviour.
In this case `@disable` is very useful.

```d
struct Archive
{
    string fileName;

    @disable this();             // ← cannot be called

    this(string fileName)        // ← can be called
    {
        this.fileName = fileName;
    }
}

auto archive = Archive();    // ← compilation ERROR
auto archive = Archive("file.txt"); // compiles
```

### Operator overloading

The topics covered in this chapter apply mostly for classes as well.
The biggest difference is that the behavior of assignment operation `opAssign()` cannot be overloaded for classes.

Operator overloading enables defining how user-defined types behave when used with operators.
In this context, the term overload means providing the definition of an operator for a specific type.

To better understand the use of operator overloading let us take an example:

```d
struct Duration
{
    int minute;
}

struct TimeOfDay
{
    int hour;
    int minute;
    void increment(in Duration duration)
    {
        minute += duration.minute;
        hour += minute / 60;
        minute %= 60;
        hour %= 24;
    }
}
void main()
{
    auto lunchTime = TimeOfDay(12, 0);
    lunchTime.increment(Duration(10));
}
```

A benefit of member functions is being able to define operations of a type alongside the member variables of that type.
Despite their advantages, member functions can be seen as being limited compared to operations on fundamental types.
After all, fundamental types can readily be used with operators:

```d
int weight = 50;
weight += 10;     // by an operator
```
According to what we have seen so far, similar operations can only be achieved by member functions for user-defined types:
```d
auto lunchTime = TimeOfDay(12, 0);
lunchTime.increment(Duration(10));     // by a member function
```

Operator overloading enables using structs and classes with operators as well.
For example, assuming that the `+=` operator is defined for `TimeOfDay`, the operation above can be written in exactly the same way as with fundamental types:
```d
lunchTime += Duration(10);   // by an operator, even for a struct
```
Before getting to the details of operator overloading, let's first see how the line above would be enabled for `TimeOfDay`.
What is needed is to redefine the `increment()` member function under the special name `opOpAssign(string op)` and also to specify that this definition is for the '+' character.
As it will be explained below, this definition actually corresponds to the '+=' operator:
```d
struct TimeOfDay
{
    // ...
    ref TimeOfDay opOpAssign(string op)(in Duration duration)//(1)
    if (op == "+")                                           //(2)
    {
        minute += duration.minute;
        hour += minute / 60;
        minute %= 60;
        hour %= 24;
        return this;
    }
}

```

The template definition consists of two parts:

1. `opOpAssign(string op)`: This part must be written as is and should be accepted as the name of the function. We will see below that there are other member functions in addition to `opOpAssign`.
2. `if (op == ”+” )`: `opOpAssign` is used for more than one operator overload. '"+"' specifies that this is the operator overload that corresponds to the '+' character.

Also note that this time the return type is different from the return type of the `increment()` member function: it is not void anymore.
We will discuss the return types of operators later below.
Behind the scenes, the compiler replaces the uses of the `+=` operator with calls to the `opOpAssign!"+"` member function:
```d
lunchTime += Duration(10);
// The following line is the equivalent of the previous one
lunchTime.opOpAssign!"+"(Duration(10));
```

Note that the operator definition that corresponds to `+=` is defined by `+`, not by `+=`.
The Assign in the name of `opOpAssign()` already implies that this name is for an assignment operator.
Being able to define the behaviors of operators brings a responsibility: the programmer must fulfil expectations.
As an extreme example, the previous operator could have been defined to decrement the time value instead of incrementing it. 
However, people who read the code would still expect the value to be incremented by the `+=` operator.

To some extent, the return types of operators can also be chosen freely.
Still, general expectations must be fulfilled for the return types as well.
Keep in mind that operators that behave unnaturally would cause confusion and bugs.

For a list of all the operators that can be overloaded, check out this [link](https://dlang.org/spec/operatoroverloading.html).

#### Defining more than one operator at the same time

To keep the code samples short, we have used only the `+=` operator above.
It is conceivable that when one operator is overloaded for a type, many others would also need to be overloaded.
For example, the `++`, `+`, `–`, `-` and `-=` operators are also defined for the following `Duration`:
```d
struct Duration
{
    int minute;
    ref Duration opUnary(string op)()
    if (op == "++")
    {
        ++minute;
        return this;
    }

    ref Duration opUnary(string op)()
    if (op == "--")
    {
        --minute;
        return this;
    }

    ref Duration opOpAssign(string op)(in int amount)
    if (op == "+")
    {
        minute += amount;
        return this;
    }

    ref Duration opOpAssign(string op)(in int amount)
    if (op == "-")
    {
        minute -= amount;
        return this;
    }
}
```
The operator overloads above have code duplications.
The only differences between the similar functions are the operators that are used.
Such code duplications can be reduced and sometimes avoided altogether by string mixins.
We will see the `mixin` keyword in a later lab, but let's see briefly how this keyword helps with operator overloading.
`mixin` inserts the specified string as source code right where the `mixin` statement appears in code.
The following struct is the equivalent of the one above:
```d
struct Duration
{
    int minute;

    ref Duration opUnary(string op)()
    if ((op == "++") || (op == "--"))
    {
        mixin(op ~ "minute;");
        return this;
    }

    ref Duration opOpAssign(string op)(in int amount)
    if ((op == "+") || (op == "-"))
    {
        mixin("minute " ~ op ~ "= amount;");
        return this;
    }
}
```
If the `Duration` objects also needs to be multiplied and divided by an amount, all that is needed is to add two more conditions to the template constraint:
```d
struct Duration
{
    // ...
    ref Duration opOpAssign(string op)(in int amount)
    if ((op == "+") || (op == "-") || (op == "*") || (op == "/"))
    {
        mixin ("minute " ~ op ~ "= amount;");
        return this;
    }
}
```
In fact, the template constraints are optional:
```d
ref Duration opOpAssign(string op)(in int amount)
/* no constraint */
{
    mixin ("minute " ~ op ~ "= amount;");
    return this;
}
```

### Practice
Navigate to `demo/opov/`. Implement the operator overloadings needed to make the unittests pass.

### alias this

`alias this` enables automatic type conversions for a user-defined type.
```d
alias member_variable_or_member_function this;
```
`alias this` enables the specific conversion from the user-defined type to the type of that member.
The value of the member becomes the resulting value of the conversion.

```d
struct S
{
    int x;
    alias x this;
}

int foo(int i)
{
    return i * 2;
}

void test()
{
    S s;
    s.x = 7;
    int i = -s;  // i == -7
    i = s + 8;   // i == 15
    i = s + s;   // i == 14
    i = 9 + s;   // i == 16
    i = foo(s);  // implicit conversion to int
}
```
If the member used as an `alias this` is a `class` or `struct`, undefined lookups will be forwarded to that member.

### Practice
Navigate to `demo/alias-this/`. Add the necessary `alias this` so as to make the unittest pass.

## Classes

The focus of this section is to understand how the concepts presented above apply to classes.

Recap from the introductory lab:
> The fundamental difference between **structs** and **classes** is that the former are **value** types, while the latter are **reference** types.
This means that whenever a `struct` is passed as an argument to an lvalue function parameter, the function will operate on a copy of the object.
When a `class` is passed as an argument to an lvalue function parameter, the function will receive a reference to the object.

The other differences outlined below are mostly due to this fact.

### Class variables may be `null`

This is because class variables, unlike struct variables, do not have values themselves.
They are just references to a given class object that is constructed with `new`.
```d
MyClass referencesAnObject = new MyClass;
assert(referencesAnObject !is null);

MyClass variable;   // does not reference an object
assert(variable is null);
```
That's why comparing a reference to `null` shouldn't be done using the `==` or `!=` operators.
Doing this will lead to a compilation error.
> This is because these two operators may need to consult the values of the members of the objects and that attempting to access the members through a potentially `null` variable would cause a memory access error. For that reason, class variables must always be compared by the `is` and `!is` operators.

### Copying

Copying affects only the class variables, not the actual class objects.
Having a class variable defined as a copy of some other makes both variables point to the same class object.
The actual object is not copied, but it can now be accessed through two different references.
```d
auto variable2 = variable1;
```
If we actually need to copy the object, then the class must provide a member function for that purpose.
This function must create and return a new class object.
```d
class Foo
{
    S      o;  // assume S is a struct type
    char[] s;
    int    i;

    this(S o, const char[] s, int i)
    {
        this.o = o;
        this.s = s.dup;   // explicitly copies slice
        this.i = i;
    }

    Foo dup() const  // provides new copy
    {
        return new Foo(o, s, i);
    }
}
```

This piece of code creates a new object by copying an existing one.
```d
auto var1 = new Foo(S(1.5), "hello", 42);
auto var2 = var1.dup();
```


### Destruction
The syntax for the destructor is the same as for the structs.
```d
~this()
{
    // ...
}
```
However, different from structs, class destructors are not executed at the time when the lifetime of a class object ends.
As we have seen above, the destructor is executed some time in the future during a garbage collection cycle.

Class destructors must comply with the following rules:
- A class destructor must not access a member that is managed by the garbage collector. This is because garbage collectors are not required to guarantee that the object and its members are finalized in any specific order. All members may have already been finalized when the destructor is executing.
- A class destructor must not allocate new memory that is managed by the garbage collector. This is because garbage collectors are not required to guarantee that they can allocate new objects during a garbage collection cycle.

Violating these rules leads to undefined behaviour.
```d
class C
{
    ~this()
    {
        auto c = new C();    // ← WRONG: Allocates explicitly
        auto arr = [ 1 ];    // ← WRONG: Allocates indirectly
    }
}

void main()
{
    auto c = new C();
}
```
```d
core.exception.InvalidMemoryOperationError@(0)
```

### Operator overloading
Other than the fact that `opAssign` cannot be overloaded for classes, operator overloading is the same as structs.
For classes, the meaning of `opAssign` is always associating a class variable with a class object.

### Inheritance and method overriding

Recap from the introductory lab:

D classes are very similar to Java classes.
- classes can inherit a single class
- `super` has the same meaning as in Java
- overriding rules are very similar
- classes can implement any number of interfaces

```d
class Square
{
    size_t length;
    this(size_t length) { this.length = length; }
    size_t area() { return length*length; }
    size_t perimeter() { return 4*length; }
}
 
class Rectangle : Square
{
    size_t width;
    this(size_t length, size_t width)
    {
        super(length);
        this.width = width;
    }
 
    override size_t area() { return length*width; }
    override size_t perimeter() { return 2*(length + width); }
}
```

### Practice
Navigate to `demo/inheritance/`. Read the comments in `inh.d` and implement the `TODO`.

### Templated structs and classes

Structs and classes can be used in conjuction with templates.

```d
class C(T)
{
    T a;
    this(T a)
    {
        this.a = a;
    }

    T foo(T b)
    {
        return a * b;
    }
}

void main()
{
    int num = 10;
    auto c = new C!int(10);
    assert(c.a == 10);
    assert(c.foo(10) == 100);
}
```

### Practice

Navigate to `demo/nullable/`.
Implement a [Nullable](https://dlang.org/library/std/typecons/nullable.html#2) object.
In D, there are certain types that cannot be `null` (such as `int`, `struct` objects etc.), also there are algorithms that work only for types that can be in the null state; for those algorithms to work with non-nullable types, an abstraction is considered in the form of a `Nullable` object.
- Implement the `Nullable(T)` struct by having a templated field which is the value and a `boolean` that keeps track whether the value is `null` or not; the `Nullable` object is considered `null` if the field holds the `.init` value.
- Implement the methods:
1. `get`: returns the value of the object if not `null`; if `null`, halts execution raising an assert error with the appropriate message;
2. `opAssign`: a `Nullable!T` object can be assigned a value of type `T`;
3. a constructor that takes a value of type `T`;

What is the problem with this implementation?

## Acknowledgement

The text of this lab was inspired by the book "Programming in D" by Ali Çehreli.
