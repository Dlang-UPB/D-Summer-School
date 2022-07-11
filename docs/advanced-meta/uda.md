---
title: User Defined Attributes (UDAs) 
parent: Improvements
grand_parent: Advanced Meta-Programming
nav_order: 3
---
# User Defined Attributes (UDAs)

UDAs stand for [User-Defined Attributes](https://dlang.org/spec/attribute.html#uda).
They are compile-time expressions that can be attached to a declaration.
These attributes can then be queried, extracted, and manipulated at compile time. 
They have no runtime component.
Simply put, it's as if you'd give a variable some _tags_, but only at compile time.
And obviously, your code can make compile-time decisions based on these tags

## Demo

The theory may sound a bit strange, but it's really not the case.
Look at the first `unittest` in `demo/uda/uda.d`.
The UDA's of any variable can be obtained by using `__traits(getAttributes, ...)`.

The second `unittest` displays a UDA "accessor": [`hasUDA`](https://dlang.org/library/std/traits/has_uda.html).
It receives 2 template parameters: the variable whose UDA we're searching for and the value of the UDA.

We can even use variables as UDAs provided their values are known at compile time.
See for yourself in the third `unittest`

## Logger

Use a UDA to disable logging for some of the fields in a `struct`.
You are free to create your own `struct` and UDAs.
Make sure you add a `unittest` for your UDAs.