// Hint: templates attribute inference

int plusOne(int a)
{
    return a + 1;
}

void f() pure nothrow @nogc @safe
{
    // Error: pure function 'f' cannot call impure function 'plusOne'
    // Error: safe function 'f' cannot call system function 'plusOne'
    // Error: @nogc function 'f' cannot call non-@nogc function 'plusOne'
    // Error: 'plusOne' is not nothrow
    plusOne(3);
}
