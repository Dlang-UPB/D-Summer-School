# Introduction to D

## Syntax

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

Most C programs require minimal changes in order to be compiled with the D compiler.
So do not worry, even if you don't have any previous experience in D, you will be able to understand most of the programs written in it because the syntax is extremely similar to the C one.

Now, using the above code snippet, let us delve into the D specific concepts.

## Imports

In D, `imports` represent the counterpart of the C `include` directive.
However there are 2 fundamental differences:

1. Imports may selectively specify which symbols are to be imported. For example, in the above code snippet, the full standard IO module of the standard library is imported, even though only the `printf` function is used.
This results in a degradation in compile time since there is a larger symbol pool that needs to be examined when trying to resolve a symbol.
In order to fix this, we can replace the blunt import with:
```d
import std.stdio : printf;
```

1. Imports may be used at any scope level.
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

## Data Types

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

## Arrays

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

### Slicing

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

### Array operations

1. Array setting:

    ```d
    void main()
    {
        int[3] a = [1, 2, 3];
        int[3] c = [ 1, 2, 3, 4];  // error: mismatched sizes
        int[] b = [1, 2, 3, 4, 5];
        a = 3;                     // set all elements of a to 3 
        b = 5;                     // set all elements of b to 5
        a[] = 2;                   // same as `a = 3`; using an empty slice is the same as slicing the full array
        b = a[0 .. $];             // $ evaluates to the length of the array (in this case 10)
        b = a[];                   // semantically equivalent to the one above
        b = a[0 .. a.length]       // semantically equivalent to the one above
        b[] = a[];                 // semantically equivalent to the one above
        b[2 .. 4] = 4              // same as b[2] = 4, b[3] = 4
        b[0 .. 4] = a[0 .. 4]      // error, a does not have 4 elements
        a[0 .. 3] = b              // error, operands have different length
    }
    ```
        
    **.length** is a builtin array property.
    For an extensive list of array properties click [here](https://dlang.org/spec/arrays.html#array-properties).
    
2. Array Concatenation:

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

## Practice

Navigate to `demo/slice` directory.
Inspect and run the file `slice.d`.
What happened here? Why?

[Quiz](./quiz/slice.md)
    
3. Vector operations:

    ```d
    void main()
    {
        int[] a = [1, 2, 3];
        int[] b;
        int[] c;
     
        b[] = a[] + 4;         // b = [5, 6, 7]
        c[] = (a[] + 1) * b[]  // c = [10, 18, 28]
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

## Practice

Navigate to `array-median` directory.
Open and inspect the file `arrayMedian.d`.
For this exercise, please add your solution inside the `medianElem` function.

Compute the [median element](https://www.geeksforgeeks.org/median/) of an unsorted integer array. For this, you will have to:
- Sort the array: implement any sorting algorithm you wish.
- Eliminate the duplicates: once the array is sorted, eliminating the duplicates is trivial.
- Check if the length of the array is **odd** or **even** and then return the [median element](https://www.geeksforgeeks.org/median/).

## Associative Arrays (AA)

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
}
```

### AA Operations

1. Removing keys:

    ```d
    void main()
    {
        int[string] aa;    
        aa["hello"] = 3;           
     
        aa.remove("hello")     // removes the pair ("hello", 3)
    }
    ```
    
    `remove(key)` does nothing if the given key does not exist and returns `false`.
    If the given key does exist, it removes it from the AA and returns `true`.
    All keys can be removed by using the method `clear`.
    
2. Testing membership:

    ```d
    void main()
    {
        int[string] aa;    
        aa["hello"] = 3;
     
        int* p;
        p = "hello" in aa;
     
        if (p)
        {
            *p = 4;  // update value associated with key; aa["hello"] == 4
        }
    }
    ```
    
    The "i" expression yields a pointer to the value if the key is in the associative array, or `null` if not.

    For more advanced operations on AAs check this [link](https://dlang.org/spec/hash-map.html#construction_assignment_entries).
    For an exhaustive list of the AA properties check this [link](https://dlang.org/spec/hash-map.html#properties).

## Practice

Find the [majority element](https://leetcode.com/problems/majority-element/) in a string array using builtin associative arrays.
You can start your implementation using the skeleton inside `majority-element` directory.

### C to D

Go to this [link](https://github.com/TheAlgorithms/C/tree/master/searching).
You will find a series of searching algorithms, each implemented in C in its own file.
- Choose one algorithm and port it to D with minimum modifications.
- Update the code using D specific features to improve the code (fewer lines of code, increase in expressiveness etc.).

## Structs

In D, structs are simple aggregations of data and their associated operations on that data:

```d
struct Rectangle
{
    size_t length, width;
    int id;
 
    size_t area() { return length*width; }
    size_t perimeter() { return 2*(length + width); }
    size_t isSquare() { return length == width; }
    void setId(int id) { this.id = id; }
}
```    

## Classes

In D, classes are very similar with java classes:

1. Classes can implement any number of interfaces
1. Classes can inherit a single class
1. Class objects are instantiated by reference only
1. super has the same meaning as in Java
1. overriding rules are very similar

The fundamental difference between **structs** and **classes** is that the former are **value** types, while the latter are **reference** types.
This means that whenever a struct is passed as an argument to an lvalue function parameter, the function will operate on a copy of the object.
When a class is passed as an argument to an lvalue function parameter, the function will receive a reference to the object.

Both **structs** and **classes** will be covered more in depth in a further lab.

## Practice

Navigate to the `demo/struct-class` directory.
You will find 2 files implementing the same program.
One uses a struct as a data container, while the other uses a class.

- Compile both files and measure the run time of each program. How do you explain the differences?
- How do you explain the output differences? How we can change the code for structs so both versions produce the same output?

[Quiz](./quiz/struct-class.md)

[Quiz](./quiz/struct-class-output.md)

Navigate to the `demo/ref-vs-value` directory.
Inspect the file and run the code.
Now let's see how arrays behave as function parameters.
The next quiz can be tricky but it will help us better understand how arrays work.
Hint: an array is a struct that contains a `length` property and a pointer to the actual data.

[Quiz](./quiz/ref-vs-value.md)

## Functions

Functions are declared the same as in C. In addition, D offers some convenience features like:

1. Uniform function call syntax (UFCS): allows any call to a free function `fun(a)` to be written as a member function call: `a.fun()`

    ```d
    import std.algorithm : group;
    import std.range : chain, dropOne, front, retro;
    [1, 2].chain([3, 4]).retro; // 4, 3, 2, 1
    [1, 1, 2, 2, 2].group.dropOne.front; // (2, 3)
     
    front(dropOne(group([1, 1, 2, 2, 2])));
    ```

## Practice

Let's go back to the `array-median` directory.
This time we want to find the [median element](https://www.geeksforgeeks.org/median/) using functions from the [std.algorithm](https://dlang.org/phobos/std_algorithm.html) package.
Use UFCS for an increase in expressiveness.
Observe the increase in performance achieved by using functions from the standard library

2. Overloading:

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
    
3. Default parameters:

    ```d
    void fun(int a, int b=8) {}
     
    void main()
    {
        fun(7);    // calls fun(7, 8)
        fun(2, 3); // calls fun(2, 3) 
    }
    ```
        
    A function may have any number of default parameters. If a default parameter is given, all following parameters must also have default values.
    
4. Auto return type:

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

## Practice

Navigate to `demo/voldemort` directory. Inspect and run the code inside `voldermort.d`.

Now navigate to `intro/voldemort` directory. 
`Result` is a struct declared inside `fun`'s scope.
However we want to be able to use it in `main` as well.
Inspect the file.
Does it compile?
Why?
Fix the issue.
    
## Unittests

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

## Practice

Navigate to the `demo/binary-search` directory.
Inspect the source file binarySearch.d.
As the name implies, a binarySearch algorithm is implemented on integers.
Compile and run the file.

- Write a unittest function that tests some corner cases.
Are there any bugs in the algorithm implementation?
If so, fix them.
- Rewrite the binarySearch algorithm to make use of slices.
   
## Contract Programming

Contracts are a breakthrough technique to reduce the programming effort for large projects.
Contracts are the concept of preconditions, postconditions and errors.

### Preconditions/Postconditions

The pre contracts specify the preconditions before a statement is executed. The most typical use of this would be in validating the parameters to a function.
The post contracts validate the result of the statement.
The most typical use of this would be in validating the return value of a function and of any side effects it has.
In D, pre contracts begin with in, and post contracts begin with out.
They come at the end of the function signature and before the opening brace of the function body.

```d
int fun(ref int a, int b)
in (a > 0)
in (b >= 0, "b cannot be negative!")
out (r; r > 0, "return must be positive")
out (; a != 0)
{
    // function body
    return 0;
}
 
int fun(ref int a, int b)
in
{
    assert(a > 0);
    assert(b >= 0, "b cannot be negative!");
}
out (r)
{
    assert(r > 0, "return must be positive");
    assert(a != 0);
}
do
{
    // function body
    return 0;
}
```

The two functions are almost identical semantically.
The expressions in the first are lowered to contract blocks that look almost exactly like the second, except that a separate block is created for each expression in the first, thus avoiding shadowing variable names.

[Quiz](./quiz/function-overloading.md)

## Practice

Navigate to the `distribute-sum` directory.
Inspect the source file distribute.d and follow the instructions.

- Complete the `distribute` function.
- Write an `in` contract that ensures the value of the first argument(`sum`) is positive.
- Write an `out` contract that ensures the value of `sum` is equal to `first` + `second`.

### Invariants

Invariants are used to specify characteristics of a class or struct that must always be true (except while executing a member function).
For example, a class representing a date might have an invariant that the day must be 1..31 and the hour must be 0..23:

```d
class Date
{
    int day;
    int hour;
 
    this(int d, int h)
    {
        day = d;
        hour = h;
    }
 
    invariant
    {
        assert(1 <= day && day <= 31);
        assert(0 <= hour && hour < 24, "hour out of bounds");
    }
}
```

For public or exported functions, the order of execution is:
1. preconditions
1. invariant
1. function body
1. invariant
1. postconditions

## Practice

Navigate to `my-associative-array` directory.
Follow the directions in the skeleton in order to implement our very own `string : int` associative array.

For the purpose of this exercise and lab, we suggest implementing the associative array using vectors.
Feel free to go a little extra and make use of linked list, hash functions, or whatever design of a hash map you prefer.