module uda;

import std.typecons : tuple, Tuple;
import std.traits : hasUDA;

// `var` has three UDAs: 1.2, "D Summer School" and 42
@(1.2, "D Summer School", 42) int var;

unittest
{
    alias varAttributes = __traits(getAttributes, var);

    // `__traits(getAttributes, ...)` returns a tuple of all attributes.
    static assert(varAttributes == tuple(1.2, "D Summer School", 42));
}

unittest
{
    // Use `hasUDA` to check if a variable has a specific attribute.
    static assert(hasUDA!(var, "D Summer School"));
    static assert(!hasUDA!(var, 69));
}

unittest
{
    enum Foo;

    // The declaration of `x` is equivalent to `@(Foo, "another UDA") int x;`
    @Foo @("another UDA") int x;

    // UDAs can also be chained and you can use variables as UDAs.
    // Of course, these variables must be known at compile time, i.e. enums.
    static assert(hasUDA!(x, Foo));
    static assert(hasUDA!(x, "another UDA"));

    struct S
    {
        int a;
        string s;
    }

    @S(42, "D Summer School") int y;

    // You can use structs or templates as UDAs too.
    static assert(hasUDA!(y, S));
    static assert(hasUDA!(y, S(42, "D Summer School")));

    // Notice that only the struct itself is the UDA and not its members.
    static assert(!hasUDA!(y, 42));
    static assert(!hasUDA!(y, "D Summer School"));
}
