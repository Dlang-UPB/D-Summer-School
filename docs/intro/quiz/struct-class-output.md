---
nav_exclude: true
---
## Question Text

What is the cause of the difference between the outputs in the previous struct-class example?

## Question Answers

- There is a bug in the struct implementation
+ Structs are passed to functions by value, classes are passed by reference
- The struct was not correctly instantiated, so the default int value was printed
- Classes don't have a deterministic behavior in the given example

## Feedback

This comes to the fundamenta difference between classes and structs.
Structs are passed by value to functions, meaning that if we pass a struct to a function a copy of it will be created and used, and the actual struct will be unmodified
