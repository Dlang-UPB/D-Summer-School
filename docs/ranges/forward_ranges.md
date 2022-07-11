---
title: Forward Range
parent: Ranges
nav_order: 4
---
# Forward Range

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

In order to make the resultant range finite as well, the range that is returned by cycle is also passed through *take()*.
The output consists of the first twenty elements of cycling through the first five elements of *FibonacciSeries*:

```
[0, 1, 1, 2, 3, 0, 1, 1, 2, 3, 0, 1, 1, 2, 3, 0, 1, 1, 2, 3]
```

Notice the importance of laziness in this example: the first four lines above merely construct range objects that will eventually produce the elements.
The numbers that are part of the result are calculated by *FibonacciSeries.popFront()* as needed.
