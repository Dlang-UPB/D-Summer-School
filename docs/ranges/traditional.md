---
title: Traditional implementations of algorithms
parent: Ranges
nav_order: 1
---
# Traditional implementations of algorithms

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
