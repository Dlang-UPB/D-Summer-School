module compile_time_reflection;

unittest
{
    // Many `__traits` are used for checking various properties:
    struct StructWithCopyConstructor
    {
        this (ref StructWithCopyConstructor rhs) { }
    }

    assert(__traits(hasCopyConstructor, StructWithCopyConstructor));

    int[3] staticArr;
    int[string] associativeArr;

    assert(__traits(isStaticArray, staticArr));
    assert(__traits(isAssociativeArray, associativeArr));
}

unittest
{
    // Other `__traits`, however, have more complex return values:
    struct S
    {
        int member;

        string foo() { return "bar"; }
    }

    S obj;

    obj.member = 2;
    assert(2 == obj.member);

    // Equivalent to `obj.member = 1`.
    // This is useful when multiple unrelated types define the same member.
    __traits(getMember, obj, "member") = 1;
    assert(1 == obj.member);

    // Equivalent to `obj.foo()`.
    // Here `__traits(getMember)` returns a function that we can call.
    assert("bar" == __traits(getMember, obj, "foo")());
}

void main() { }
