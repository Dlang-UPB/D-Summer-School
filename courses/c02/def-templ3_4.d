module def_templ;

ulong fib(uint N)()
{
    static if (N <= 1)
        return N;
    else
        return fib!(N - 2)() + fib!(N - 1)();
}

void fibDisplay(uint N)()
{
    static if (N > 0)
        fibDisplay!(N - 1)();

    import std.stdio;
    writef("fib ! %2u () == %19u\n", N, fib!N());
}

void main(string[] args)
{
    fibDisplay!45();

    auto x = fib!(10)();
    assert(x == 55);
}
