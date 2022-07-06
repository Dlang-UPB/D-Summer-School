---
title: Classes
parent: Introduction to D
nav_order: 7
---

# Classes

In D, classes are very similar with java classes:

1. Classes can implement any number of interfaces
1. Classes can inherit a single class
1. Class objects are instantiated by reference only
1. super has the same meaning as in Java
1. overriding rules are very similar

The fundamental difference between **structs** and **classes** is that the former are **value** types, while the latter are **reference** types.
This means that whenever a struct is passed as an argument to an lvalue function parameter, the function will operate on a copy of the object.
When a class is passed as an argument to an lvalue function parameter, the function will receive a reference to the object.

Both **structs** and **classes** will be covered more in depth in a further lab.

## Practice

1. Navigate to the `demo/struct-class` directory.
You will find 2 files implementing the same program.
One uses a struct as a data container, while the other uses a class.

- Compile both files and measure the run time of each program. How do you explain the differences?
- How do you explain the output differences? How we can change the code for structs so both versions produce the same output?

To test your knwoledge answer the following quizzes:

[Quiz 1](./quiz/struct-class.md)

[Quiz 2](./quiz/struct-class-output.md)

2. Navigate to the `demo/ref-vs-value` directory.
Inspect the file and run the code.
Now let's see how arrays behave as function parameters.
The next quiz can be tricky but it will help us better understand how arrays work.
Hint: an array is a struct that contains a `length` property and a pointer to the actual data.

This one is more difficult, see if you can get this right: [Quiz 3](./quiz/ref-vs-value.md)
