---
title: Bidirectional Range
parent: Ranges
nav_order: 5
---
# Bidirectional Range

*BidirectionalRange* provides two member functions over the member functions of ForwardRange: *back* and *popBack*.
*back* is similar to *front*: it provides access to the last element of the range.
*popBack()* is similar to *popFront()*: it removes the last element from the range.

Importing *std.array* automatically makes slices become *BidirectionalRange* ranges.

A good BidirectionalRange example is the *std.range.retro* function.
*retro()* takes a *BidirectionalRange* and ties its *front* to *back*, and p*opFront()* to *popBack()*. As a result, the original range is iterated over in reverse order:

```d
writeln([ 1, 2, 3 ].retro);
```

The output:

```
[3, 2, 1]
```

Let's define a range that behaves similarly to the special range that retro() returns.
Although the following range has limited functionality, it shows how powerful ranges are:

```d
import std.array;
import std.stdio;

struct Reversed
{
    int[] range;

    this(int[] range)
    {
        this.range = range;
    }

    bool empty() const
    {
        return range.empty;
    }

    int front() const
    {
        return range.back;  // ← reverse
    }

    int back() const
    {
        return range.front; // ← reverse
    }

    void popFront()
    {
        range.popBack();    // ← reverse
    }

    void popBack()
    {
        range.popFront();   // ← reverse
    }
}

void main()
{
    writeln(Reversed([ 1, 2, 3]));
}
```

The output is the same as *retro()*:

```
[3, 2, 1]
```

## Practice

Upgrade our `LinkedList` to a `BidirectionalRange`. A few notes:
- a bidirectional range cannot be infinite, so you will have to transform `LinkedList` into a finite range.
- you will need an extra pointer to save the address of the previous element so that you can iterate the range backwards. Alternatively, you can use a single pointer, however, that will be suboptimal from a time perspective.

Test this new functionality, by a adding a unittest that makes use of the [isBidirectionalRange](https://dlang.org/phobos/std_range_primitives.html#isBidirectionalRange) primitive.
