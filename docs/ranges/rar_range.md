---
title: Random Access Range
parent: Ranges
nav_order: 6
---

# Random Access Range

*RandomAccessRange* represents ranges that allow accessing elements by the *[]* operator.
*[]* operator is defined by the *opIndex()* member function.

It is natural that every type would define the *opIndex()* member function according to its functionality.
However, computer science has an expectation on its algorithmic complexity: random access must take constant time.
Constant time access means that the time spent when accessing an element is independent of the number of elements in the container.
Therefore, no matter how large the range is, element access should not depend on the length of the range.

In order to be considered a *RandomAccessRange*, one of the following conditions must also be satisfied:

- to be an infinite *ForwardRange*
or
- to be a *BidirectionalRange* that also provides the *length* property

## Infinite Random Access Range

The following are all of the requirements of a *RandomAccessRange* that is based on an infinite *ForwardRange*:

- *empty*, *front* and *popFront()* that *InputRange* requires
- *save* that *ForwardRange* requires
- *opIndex()* that *RandomAccessRange* requires
- the value of *empty* to be known at compile time as *false*

We were able to define *FibonacciSeries* as a *ForwardRange*.
However, *opIndex()* cannot be implemented to operate at constant time for *FibonacciSeries* because accessing an element requires accessing all of the previous elements first.

As an example where *opIndex()* can operate at constant time, let's define an infinite range that consists of squares of integers.
Although the following range is infinite, accessing any one of its elements can happen at constant time:

```d
class SquaresRange
{
    int first;

    this(int first = 0)
    {
        this.first = first;
    }

    enum empty = false;

    int front() const
    {
        return opIndex(0);
    }

    void popFront()
    {
        ++first;
    }

    SquaresRange save() const
    {
        return new SquaresRange(first);
    }

    int opIndex(size_t index) const
    {
         /* This function operates at constant time */
        immutable integerValue = first + cast(int)index;
        return integerValue * integerValue;
    }
}
```

Although no space has been allocated for the elements of this range, the elements can be accessed by the *[]* operator:

```d
void main()
{
    auto squares = new SquaresRange();

    writeln(squares[5]);
    writeln(squares[10]);
}
```

The output contains the elements at indexes 5 and 10:

```
25
100
```

The element with index 0 should always represent the first element of the range.
We can take advantage of `popFrontN()` when testing whether this really is the case:

```d
    squares.popFrontN(5);
    writeln(squares[0]);
```

The first 5 elements of the range are 0, 1, 4, 9 and 16; the squares of 0, 1, 2, 3 and 4.
After removing those, the square of the next value becomes the first element of the range:

```d
25
```

Being a *RandomAccessRange* (the most functional range), *SquaresRange* can also be used as other types of ranges.
For example, as an InputRange when passing to *filter()*:

```d
    bool are_lastTwoDigitsSame(int value)
    {
        /* Must have at least two digits */
        if (value < 10)
        {
            return false;
        }

        /* Last two digits must be divisible by 11 */
        immutable lastTwoDigits = value % 100;
        return (lastTwoDigits % 11) == 0;
    }

    writeln(squares.take(50).filter!are_lastTwoDigitsSame);
```

The output consists of elements among the first 50, where last two digits are the same:

```
[100, 144, 400, 900, 1444, 1600]
```

## Finite Random Access Range

The following are all of the requirements of a *RandomAccessRange* that is based on a finite *BidirectionalRange*:

- *empty*, *front* and *popFront()* that *InputRange* requires
- *save* that *ForwardRange* requires
- *back* and *popBack()* that *BidirectionalRange* requires
- *opIndex()* that *RandomAccessRange* requires
- *length*, which provides the length of the range

As an example of a finite *RandomAccessRange*, let's define a range that works similarly to *std.range.chain*.
*chain()* presents the elements of a number of separate ranges as if they are elements of a single larger range.
Although *chain()* works with any type of element and any type of range, to keep the example short, let's implement a range that works only with int slices.

Let's name this range Together and expect the following behavior from it:

```d
    auto range = Together([ 1, 2, 3 ], [ 101, 102, 103]);
    writeln(range[4]);
```

When constructed with the two separate arrays above, *range* should present all of those elements as a single range.
For example, although neither array has an element at index 4, the element 102 should be the element that corresponds to index 4 of the collective range:

```
102
```

As expected, printing the entire range should contain all of the elements:

```d
writeln(range);
```

The output:

```
[1, 2, 3, 101, 102, 103]
```

*Together* will operate lazily: the elements will not be copied to a new larger array; they will be accessed from the original slices.

We can take advantage of variadic functions to initialize the range by any number of original slices:

```d
struct Together
{
    const(int)[][] slices;

    this(const(int)[][] slices...)
    {
        this.slices = slices.dup;

        clearFront();
        clearBack();
    }

// ...
}
```

Note that the element type is *const(int)*, indicating that this struct will not modify the elements of the ranges.
However, the slices will necessarily be modified by *popFront()* to implement iteration.

The *clearFront()* and *clearBack()* calls that the constructor makes are to remove empty slices from the beginning and the end of the original slices.·
Such empty slices do not change the behavior of *Together* and removing them up front will simplify the implementation:

```d
struct Together
{
// ...

    private void clearFront()
    {
        while (!slices.empty && slices.front.empty)
        {
            slices.popFront();
        }
    }

    private void clearBack()
    {
        while (!slices.empty && slices.back.empty)
        {
            slices.popBack();
        }
    }
}
```

We will call those functions later from *popFront()* and *popBack()* as well.

Since *clearFront()* and *clearBack()* remove all of the empty slices from the beginning and the end, still having a slice would mean that the collective range is not yet empty.
In other words, the range should be considered empty only if there is no slice left:

```d
struct Together
{
// ...

    bool empty() const
    {
        return slices.empty;
    }
}
```

The first element of the first slice is the first element of this *Together* range:

```d
struct Together
{
// ...

    int front() const
    {
        return slices.front.front;
    }
}
```

Removing the first element of the first slice removes the first element of this range as well.
Since this operation may leave the first slice empty, we must call *clearFront()* to remove that empty slice and the ones that are after that one:

```d
struct Together
{
// ...

    void popFront()
    {
        slices.front.popFront();
        clearFront();
    }
}
```

A copy of this range can be constructed from a copy of the slices member:

```d
struct Together
{
// ...

    Together save() const
    {
        return Together(slices.dup);
    }
}
```

Please note that *.dup* copies only slices in this case, not the slice elements that it contains.

The operations at the end of the range are similar to the ones at the beginning:

```d
struct Together
{
// ...

    int back() const
    {
        return slices.back.back;
    }

    void popBack()
    {
        slices.back.popBack();
        clearBack();
    }
}
```

The length of the range can be calculated as the sum of the lengths of the slices:

```d
struct Together
{
// ...

    size_t length() const·
    {
        size_t totalLength = 0;

        foreach (slice; slices)·
        {
            totalLength += slice.length;
        }

        return totalLength;
    }
}
```

**Note: Further, instead of calculating the length every time when length is called, it may be measurably faster to maintain a member variable perhaps named *len*, which always equals the correct length of the collective range.
That member may be calculated once in the constructor and adjusted accordingly as elements are removed by *popFront()* and *popBack()*.**

One way of returning the element that corresponds to a specific index is to look at every slice to determine whether the element would be among the elements of that slice:

```d
struct Together
{
// ...

    int opIndex(size_t index) const
    {
        /* Save the index for the error message */
        immutable originalIndex = index;

        foreach (slice; slices)
        {
            if (slice.length > index)
            {
                return slice[index];

            }
            else
            {
                index -= slice.length;
            }
        }

        throw new Exception(
            format("Invalid index: %s (length: %s)",
                   originalIndex, this.length));
    }
}
```

**Note: This *opIndex()* does not satisfy the constant time requirement that has been mentioned above.
For this implementation to be acceptably fast, the slices member must not be too long.**

This new range is now ready to be used with any number of int slices.
With the help of *take()* and *array()*, we can even include the range types that we have defined earlier in this chapter:

```d
    auto range = Together(FibonacciSeries().take(10).array,
                          [ 777, 888 ],
                          (new SquaresRange()).take(5).array);

    writeln(range.save);
```

The elements of the three slices are accessed as if they were elements of a single large array:

```d
[0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 777, 888, 0, 1, 4, 9, 16]
```

We can pass this range to other range algorithms.
For example, to *retro()*, which requires a *BidirectionalRange*:

```d
writeln(range.save.retro);
```

The output:

```d
[16, 9, 4, 1, 0, 888, 777, 34, 21, 13, 8, 5, 3, 2, 1, 1, 0]
```
