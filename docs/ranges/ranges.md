---
nav_order: 5
title: Ranges
has_children: true
---
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
