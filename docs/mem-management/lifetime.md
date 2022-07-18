---
title: Lifetime
parent: Memory Management
nav_order: 2
---

## Lifetime

The lifetime of an entity can be defined as the location in the program where it exists, so it has to do with when a variable is created and destroyed.
This does not necessarily coincide with the scope - this is why memory leaks are hard to recover from.

Variables local to a scope begin their lifetime when they are defined, and end it at the end of the scope.
They are kept in the current program frame/function call ("the stack").
Their lifetime is said to be automatic, because they are automatically managed by the compiler.
This should not be confused with the automatically managed dynamic memory, which we will discuss later in this session.

Global and static variables begin their lifetime at the start of the program and end it at the end of the program.
They are kept in specific sections of the program (commonly, in ELFs, the main sections of interest are: `.rodata`, `.data` and `.bss`).
Their lifetime is static.

A summary about the ELF sections:
- `.rodata` holds **global** or **static** initialized, read-only data, like string literals and global constants
- `.data` holds **global** or **static** initialized data
- `.bss` holds **global** or **static** uninitialized data
  - the `.bss` section will be zeroed when the process is loaded
  - on disk, the executable file holds only the sizes and offsets for these variables, the actual space is reserved when the binary is loaded into memory

Because we want to extend the lifetime of entities beyond a single program frame, using the stack is not suitable.
Also, if the size or number of entities is not known at compile time, we again cannot use the stack, as we don't know at compile time how much memory we need to reserve for our runtime variables.
The solution to this is to designate a region of the program space from which to use memory dynamically ("the heap"), at runtime, keeping track of which blocks of memory have been allocated.
This memory can be managed manually, by the programmer, or automatically, by the runtime of the language.
