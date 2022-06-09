---
title: Extended Practice
parent: Advanced Meta-Programming
nav_order: 6
---
# Extended Practice

## Log Arrays

Now our logger elegantly handles basic data types.
But what if we want to log an array?
We'd like to log an array the same way we would write it in code, like so:
```d
[1, 2, 3].log(LogLevel.Info) == "[info] logger.d: [1, 2, 3]"'
```

To do this, we need to add the metadata to the returned string and then iterate the elements of the array and add each element `.to!string` to the returned string.

Implement another `log` function whose template constraint enforces the logged data to be an array.
Use a [trait](https://dlang.org/phobos/std_traits.html).
To create the logged string efficiently, use an [`Appender`](https://dlang.org/library/std/array/appender.html#2).
As always, add a new `unittest` to verify the correctness of your newly implemented `log` function.

## Log Structures and Classes

What if we want to log a structure?
Or worse, a structure with nested structure members?
Take a look at the `unittest` below:
```d
unittest
{
    struct Stats
    {
        long souls;
        bool optional;
    }

    struct Boss
    {
        string name;
        int number;
        Stats stats;
    }

    Boss firstBoss = Boss("Iudex Gundyr", 1, Stats(3000, false));
    assert("[warn] logger.d: Boss(Iudex Gundyr, 1, Stats(3000, false), )" == firstBoss.log(LogLevel.Warning));
}
```
Paste the unittest into your code and run it.
It wil probably fail to compile.
