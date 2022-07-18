---
title: Scope
parent: Memory Management
nav_order: 1
---

## Scope

The scope of an entity can be defined as the location(s) in the program where it is accessible.

Scoping restricts access to an entity, reducing the possibility of changing the entity's state (or value, for simple types) in an unintended way (maybe from a different part of the program).
This also means that we can reuse names to refer to different entities, as long as we use them in separate scopes.

In the D programming language, a new scope is defined within ```{}``` (curly braces).
In the example below, the variables ```a``` and ```b``` are defined in two different scopes:

```d
void foo() {
    int a;
    {
        int b = 42;
    }
    writeln(b); // error, 'b' is out of scope
}
```

We can imagine scopes represented as a tree, starting from the root scope (usually at global / module level).
At every level, we inherit the visibility of all the entities that are visible in the enclosing (outer, or ancestor, if we use the tree analogy) scope.

When we access an entity by name, the name is looked up in each scope, from the innermost one outwards (or from leaf to root). If the name is not found in any of the scopes, you will get a compilation error.

We are not allowed to declare two different entities with the same name, in the same scope, even if they have different types:

```d
void main()
{
    int x = 3;
    double x = 3.14; // compilation error: 'x' is already defined
}
```

D's specification on scope statements forbids shadowing (Java does this also). In C/C++, this is NOT the case.

```d
import std.stdio;

int x = 5; // global / module scope

void foo(int x) {
    // int x = 1; // compilation error, locally declared 'x' shadows parameter 'x'
	writeln(x); // 'x' is also the name of the parameter, so it will print the value of the parameter
}

void bar(int y) {
	writeln(x); // 'x' is not defined anywhere in the scope of bar, so the compiler will look into the global scope for the name 'x'
}

void main()
{
    int x = 3;
    {
        //int x = 4; // compilation error, 'x' shadows enclosing scope's 'x'
    	writeln(x); // uses the innermost 'x'; that would be 4, but in D that declaration is illegal, so it will print 3
    }
    foo(6); // prints 6
    bar(6); // prints 5
}
```

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
