# Ranges

Ranges are an abstraction of element access.
This abstraction enables the use of great number of algorithms over great number of container types.
Ranges emphasize how container elements are accessed, as opposed to how the containers are implemented.
Simply put, ranges are objects that a foreach (TODO: add hyperlink to were we talk about foreach ) can iterate.

## Definitions:

**Container (data structure)**: Container is a very useful concept that appears in almost every program.
Variables are put together for a purpose and are used together as elements of a container.
D's containers are its core features arrays and associative arrays, and special container types that are defined in the `std.container` module.
Every container is implemented as a specific data structure.
For example, associative arrays are a hash table implementation.

Every data structure stores its elements and provides access to them in ways that are special to that data structure.
For example, in the array data structure the elements are stored side by side and accessed by an element index; in the linked list data structure the elements are stored in nodes and are accessed by going through those nodes one by one; in a sorted binary tree data structure, the nodes provide access to the preceding and successive elements through separate branches; etc.

**Algorithm (function)**: Processing of data structures for specific purposes in specific ways is called an algorithm.
For example, linear search is an algorithm that searches by iterating over a container from the beginning to the end; binary search is an algorithm that searches for an element by eliminating half of the candidates at every step; etc.

## Ranges are an integral part of D

D's slices happen to be implementations of the most powerful range *RandomAccessRange*, and there are many range features in Phobos.
It is essential to understand how ranges are used in Phobos.

Many Phobos algorithms return temporary range objects.
For example, *filter()*, which chooses elements that are greater than 10 in the following code, actually returns a range object, not an array:

```d
import std.stdio;
import std.algorithm;

void main()
{
    int[] values = [ 1, 20, 7, 11 ];
    writeln(values.filter!(value => value > 10));
}
```

*writeln* uses that range object lazily and accesses the elements as it needs them:

```console
[20, 11]
```

That output may suggest that *filter()* returns an *int[]* but this is not the case.
We can see this from the fact that the following assignment produces a compilation error:

```d
int[] chosen = values.filter!(value => value > 10); // ← compilation ERROR
```

The error message contains the type of the range object:

```console
Error: cannot implicitly convert expression (filter(values)) of type FilterResult!(__lambda2, int[]) to int[]
```
*Note*: The type may be different in the version of Phobos that you are using.

## Traditional implementations of algorithms

In traditional implementations of algorithms, the algorithms know how the data structures that they operate on are implemented.
For example, the following function that prints the elements of a linked list must know that the nodes of the linked list have members named *element* and *next*:

```d
struct Node
{
    int element;
    Node * next;
}

void print(const(Node) * list)
{
    for ( ; list; list = list.next)
    {
        write(' ', list.element);
    }
}
```

Similarly, a function that prints the elements of an array must know that arrays have a *length* property and their elements are accessed by the *[]* operator:

```d
void print(const int[] array)
{
    for (int i = 0; i != array.length; ++i)
    {
        write(' ', array[i]);
    }
}
```

Having algorithms tied to data structures makes it necessary to write them specially for each type.
For example, the functions *find()*, *sort()*, *swap()*, etc. must be written separately for array, linked list, associative array, binary tree, heap, etc.
As a result, N algorithms that support M data structures must be written NxM times.
**(Note: In reality, the count is less than NxM because not every algorithm can be applied to every data structure; for example, associative arrays cannot be sorted.)**

Conversely, because ranges abstract algorithms away from data structures, implementing just N algorithms and M data structures would be sufficient.
A newly implemented data structure can work with all of the existing algorithms that support the type of range that the new data structure provides, and a newly implemented algorithm can work with all of the existing data structures that support the range type that the new algorithm requires.

## D ranges

The minimum required interface that an object must present to be considered a range is:

```d
struct Range(T)
{
    bool empty();
    T front();
    void popFront();
}
```
*Note: Both **classes and **structs** may be used to define ranges*

### Input Range

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
This may be essential for execution speed and memory consumption

### Infinite Ranges

Another benefit of not storing elements as actual members is the ability to create infinite ranges.
Making an infinite range is as simple as having *empty* always return *false*.
Since it is constant, *empty* need not even be a function and can be defined as a variable:

```d
static immutable empty = false;                   // ← infinite range
```

As an example of this, let's design the FibonacciSeries range to be infinite:

```d
struct FibonacciSeries
{
    int current = 0;
    int next = 1;

    enum empty = false;   // ← infinite range

    int front() const
    {
        return current;
    }

    void popFront()
    {
        const nextNext = current + next;
        current = next;
        next = nextNext;
    }
}

void main()
{
    import std.stdio : writeln;
    // never ends
    foreach(n; FibonacciSeries())
        writeln(n);
}
```

**Note: Although it is infinite, because the members are of type *int*, the elements of this Fibonacci series would be wrong beyond *int.max*.**

It can be oberved that the implementation has been simplified, however the *foreach* now enters an infinite loop.
An infinite range is useful when the range need not be consumed completely right away.
For example, imagine a range that abstracts a network channel stream.
There is, essentially, an infinite number of packets that could be received on the network.
In this situation, an infinite range could be used to implement the receiving of packets.
When packets arrive, they are stored in a buffer and whenever *popFront* is called, a packet is returned to be processed.
However, there are situations where we want to process only a finite number of elements from an infinite range.
To achieve this we can use the (take)[https://dlang.org/phobos/std_range.html#take] function:

```d
void main()
{
    import std.stdio : writeln;
    import std.range : take;
    // never ends
    foreach(n; FibonacciSeries().take(10))
        writeln(n);
}
```

Although the range is infinite, by using *take*, we specify that we want to process only the first 10 elements.
*take* returns a range that is a wrapper implementation over the range that it receives.

### Forward Range

InputRange models a range where elements are taken out of the range as they are iterated over.
This means that once an *InputRange* is iterated, its elements are consumed.

Some ranges are capable of saving their states, as well as operating as an *InputRange*.
For example, *FibonacciSeries* objects can save their states because these objects can freely be copied and the two copies continue their lives independently from each other.

*ForwardRange* provides the *save* member function, which is expected to return a copy of the range.
The copy that *save* returns must operate independently from the range object that it was copied from: iterating over one copy must not affect the other copy.

In order to implement save for *FibonacciSeries*, we can simply return a copy of the object:

```d
struct FibonacciSeries
{
// ...

    FibonacciSeries save() const
    {
        return this;
    }
}
```

The returned copy is a separate range that would continue from the point where it was copied from.

We can demonstrate that the copied object is independent from the actual range with the following program.
The algorithm (std.range.popFrontN())[https://dlang.org/phobos/std_range_primitives.html#.popFrontN] in the following code removes a specified number of elements from the specified range:

```d
import std.range;
import std.stdio;

// ...

void report(T)(const dchar[] title, const ref T range)
{
    writefln("%40s: %s", title, range.take(5));
}

void main() {
    auto range = FibonacciSeries();
    report("Original range", range);

    range.popFrontN(2);
    report("After removing two elements", range);

    auto theCopy = range.save;
    report("The copy", theCopy);

    range.popFrontN(3);
    report("After removing three more elements", range);
    report("The copy", theCopy);
}
```

TODO: quiz - why doesn't *range.take(5)* does not modify the range?

The output of the program shows that removing elements from the range does not affect its saved copy:

```
                          Original range: [0, 1, 1, 2, 3]
             After removing two elements: [1, 2, 3, 5, 8]
                                The copy: [1, 2, 3, 5, 8]
      After removing three more elements: [5, 8, 13, 21, 34]
                                The copy: [1, 2, 3, 5, 8]
```

An algorithm that works with *ForwardRange* is *std.range.cycle*.
*cycle()* iterates over the elements of a range repeatedly from the beginning to the end.
In order to be able to start over from the beginning it must be able to save a copy of the initial state of the range, so it requires a *ForwardRange*.

Since *FibonacciSeries* is now a *ForwardRange*, we can try *cycle()* with a *FibonacciSeries* object.
But in order to avoid having *cycle()* iterate over an infinite range, and as a result never find the end of it, we must first make a finite range by passing *FibonacciSeries* through *take()*:

```d
writeln(FibonacciSeries().take(5).cycle.take(20));
```


### Bidirectional Range

### Random Access Range


TODO: Picture with ranges
