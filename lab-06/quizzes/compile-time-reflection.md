## Question Text

Why is inefficient about the `foreach` loop you've just written?

## Question Answers

- Using an `Appender` is inefficient compared to appending to a simple string.
- We use `string`s instead of the lower-level `char*`, which are faster due to being simple pointers.
- The names of each field is available at compile time, but we extract them at runtime.
+ The loop iterates through the members at runtime when it can do so at compile time.

## Feedback

All `__traits` are available at compile time.
In our case, the `foreach` loop iterates the members of the structure / class at runtime.
However, the compiler has all information to iterate `__traits(allMembers)` itself.
Therefore, we can **unroll** this loop and have the compiler iterate the members.
