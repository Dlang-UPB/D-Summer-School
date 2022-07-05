---
title: Manifest Constants
parent: Introduction to Meta-Programming
nav_order: 1
---
# Manifest Constants

Manifest constants are variables evaluated at compile time.
They cannot change their value.
A manifest constant is declared by using the keywork **enum**:

```d
enum i = 4;      // i is 4 of type int
enum long l = 3; // l is 3 of type long
```

Manifest constants are not lvalues, meaning their address cannot be taken. They exist only in the memory of the compiler.
Declaring a manifest constant that cannot be evaluated at compile time is an error:

```d
void main()
{
    int a = 5;
    enum b = 5 + 2;   // ok, '5' and '2' are integer literals, known at compile time
    enum b = a + 2;   // error: 'a' cannot be read at compile time  
}
```

To make the above code work, **a** should be declared as an **enum**.

Manifest constants can be seen as compile time variable declarations.

## Practice

1. Go to this [link](https://godbolt.org/z/0RGPvB).
You will find the disassembly of a code.
Observe how the call to function `sum` is translated in assembly code.
Explain the output.
