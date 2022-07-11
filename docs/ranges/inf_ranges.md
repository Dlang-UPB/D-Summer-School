---
title: Infinite Ranges
parent: Ranges
nav_order: 3
---

# Infinite Ranges

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
To achieve this we can use the [take](https://dlang.org/phobos/std_range.html#take) function:

```d
void main()
{
    import std.stdio : writeln;
    import std.range : take;
    foreach(n; FibonacciSeries().take(10))
        writeln(n);
}
```

Although the range is infinite, by using *take*, we specify that we want to process only the first 10 elements.
*take* returns a range that is a wrapper implementation over the range that it receives.

## Practice

Update our `LinkedList` implementation by making it an infinite range. If the range needs to consume more elements than it has - for example, the list was initialized with `initListOfTen` but 15 elements are taken fron it - then `T.init` should be generated and returned on the fly for the missing elements.
