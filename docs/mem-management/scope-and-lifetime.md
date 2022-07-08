---
title: Scope and Lifetime
parent: Memory Management
nav_order: 1
---

# Motivation

Before diving into memory management, let's understand the motivation for having a memory management system in a modern programming language.

# Properties of program entities

The entities that live in our programs (basic types, arrays or aggregate types like structs and classes) have a few properties, like name (used to identify the variable), address (location in program memory), type (depending on the language, it can be inferred or must be declared explicitly), with which you are already familiar.

When talking about memory management, two (less talked about) properties are of interest: scope and lifetime.

## Scope

The scope of an entity can be defined as the location(s) in the program where it is accessible.

Scoping restricts access to an entity, reducing the possibility of changing the entity's state (or value, for simple types) in an unintended way (maybe from a different part of the program). This also means that we can reuse names to refer to different entities, as long as we use them in separate scopes. We can imagine scopes represented as a tree, starting from the root scope (usually at global/file level). At every level, we inherit the visibility of all the entities that are visible in the enclosing (outer, or ancestor, if we use the tree analogy) scope.

When we access an entity by name, the name is looked up in each scope, from the innermost one outwards (or from leaf to root). If the name is not found in any of the scopes, you will get a compilation error.

```d
import std.stdio;

int x = 5; // global/file scope

void foo(int x) {
    // int x = 1; // compilation error, explained in the next code snippet
	writeln(x); // x is also the name of the parameter, so it will print the value of the parameter
}

void bar(int y) {
	writeln(x); // x is not defined anywhere in the scope of bar, so we will use the global x
}

void main()
{
    int x = 3;
    {
        //int x = 4; // compilation error, explained in the next code snippet
    	writeln(x); // uses the innermost x; that would be 4, but in D that declaration is illegal, so it will print 3
    }
    foo(6); // prints 6
    bar(6); // prints 5
}
```

D's specification on scope statements forbids shadowing (Java does this also). In C/C++, this is NOT the case.

```d
void func1(int x)
{
    int x;    // illegal, x shadows parameter x

    int y;

    { int y; } // illegal, y shadows enclosing scope's y

    void delegate() dg;
    dg = { int y; }; // ok, this y is not in the same function

    struct S
    {
        int y;    // ok, this y is a member, not a local
    }

    { int z; }
    { int z; }  // ok, this z is not shadowing the other z

    { int t; }
    { t++;   }  // illegal, t is undefined
}
```

## Lifetime

The lifetime of an entity can be defined as the location in the program where it exists, so it has to do with when a variable is created and destroyed. This does not necessarily coincide with the scope - this is why memory leaks are hard to recover from.

Variables local to a scope begin their lifetime when they are defined, and end it at the end of the scope. They are kept in the current program frame/function call ("the stack"). Their lifetime is said to be automatic, because they are automatically managed by the compiler. This should not be confused with the automatically managed dynamic memory, that we will mostly talk about for the rest of this session.

Global variables begin their lifetime at the start of the program and end it at the end of the program. They are kept in specific sections of the program (commonly, in ELFs: .data, .bss, .rodata). Their lifetime is static.

Because we want to extend the lifetime of entities beyond a single program frame, using the stack is not suitable. Also, if the size or number of entities is not known at compile time, we again cannot use the stack. The solution to this is to designate a region of the program space from which to use memory dynamically ("the heap"), at runtime, keeping track of which blocks of memory have been allocated. This memory can be managed manually, by the programmer, or automatically, by the runtime of the language.
