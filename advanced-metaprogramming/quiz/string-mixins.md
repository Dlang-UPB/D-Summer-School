## Question Text

Why does the `static foreach` in `string_mixins.d` compile just fine despite it not being part of a function?

## Question Answers

- Because `sizes` and `lengths` are `enum`s and thus only available at compile time.
- Because they define structures, which must be available at compile time.
+ Because the loop and the `mixin` are evaulated at compile time, regardless of where they are placed.
- Because code defined inside the global scope is always executed.

## Feedback

All `__traits` are available at compile time.
In our case, the `foreach` loop iterates the members of the structure / class at runtime.
However, the compiler has all information to iterate `__traits(allMembers)` itself.
Therefore, we can **unroll** this loop and have the compiler iterate the members.
