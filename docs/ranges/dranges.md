---
title: D Ranges
parent: Ranges
nav_order: 2
---
# D Ranges

The minimum required interface that an object must present to be considered a range is:

```d
struct Range(T)
{
    bool empty();
    T front();
    void popFront();
}
```
*Note: Both **classes** and **structs** may be used to define ranges*

Any object that presents the above interface is considered an *InputRange*.
*InputRange*s may be used with *foreach* statements, therefore it is not necessary to have any information about internal methods.
As long as we know that an object is an *InputRange* we can iterate over it:

```d
import std.string;

struct Student
{
    string name;
    int number;

    string toString() const
    {
        return format("%s(%s)", name, number);
    }
}

struct School
{
    Student[] students;

    bool empty() const
    {
        return students.length == 0;
    }

    // Returns a reference to the actual container member, not a copy
    ref Student front()
    {
        return students[0];
    }

    void popFront()
    {
        students = students[1 .. $];
    }
}

void main()
{
    auto school = School( [ Student("Ebru", 1),
                            Student("Derya", 2) ,
                            Student("Damla", 3) ] );

    // no need to have any information about school's internal methods
    foreach(student; school)
        writeln(student);
}
```

Note how the user of the *school* object does not need to have any information regarding the internal methods.
This is possible because behind the scenes the compiler rewrites the `foreach` loop to:

```d
for(student = school.front; !school.empty; school.popFront)
    writeln(student);
```

The elements of the *School* objects were actually stored in the students member slices.
So, *School.front* returned a reference to an existing *Student* object.

One of the powers of ranges is the flexibility of not actually owning elements.
*front* need not return an actual element of an actual container.
The returned element can be calculated each time when *popFront()* is called, and can be used as the value that is returned by *front*.
Take for example, the following range that implements a FibonnaciSeries:

```d
struct FibonacciSeries                                                                        {
    int current = 0;
    int next = 1;
    uint N;

    this(uint N)
    {
        this.N = N;
    }

    bool empty()
    {
        return N == 0;
    }

    int front() const
    {
        return current;
    }

    void popFront()
    {
        const nextNext = current + next;
        current = next;
        next = nextNext;
        --N;
    }
}

void main()
{
    import std.stdio : writeln;
    foreach(n; FibonacciSeries(10))
        writeln(n);
}
```

The elements of the series are computed **lazily** when needed.
Notice that the constructor only sets the number of Fibonnaci elements that need to be computed.
The elements are computed upon request by calling *popFront*.
This may be essential for execution speed and memory consumption.


## Practice

Navigate to the `Ranges/practice/linkedList` directory. Inspect the `linkedList.d` file. What does the code do?

- Implement the "initListOfTen" function that has the signature: "void initList(T)(ref LinkedList!T start)". This function initializes a list of 10 elements where `node(i)` contains `i`. Write a unittest to make sure the function works properly.
- Answer this [quiz](./quiz/mem.md)
- Implement the required methods such that `LinkedList` is an `InputRange`. To test the functionality, write a unittest that contains a foreach loop that iterates over a `LinkedList`.
