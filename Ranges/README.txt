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
* **Note:** The type may be different in the version of Phobos that you are using.*

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

Note how the user of the *school* object does not need to have any information regarding the internal methods.
This is possible because behind the scenes the compiler rewrites the `foreach` loop to:

```d
for(student = school.front; !school.empty; school.popFront)
    writeln(student);
```

### Forward Range

### Bidirectional Range

### Random Access Range

### Infinite Ranges

TODO: Picture with ranges
