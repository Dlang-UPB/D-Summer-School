## Question Text

In the previous example, why the class executable is significantly faster?

## Question Answers

- Classes in D are implemented more efficiently
- Structs are stored on the stack data segment, which is slower
+ Structs are value types, every time we call `get_a0` a new struct with 1000 fields is created
- Classes have faster acces to their data

## Feedback

When a variable is **pass by value**, we create a copy of the variable and it's content everytime we use it in a function.
So, for structs we are creating a million copies, while for classes only one, hence the implementation with classes is faster. 