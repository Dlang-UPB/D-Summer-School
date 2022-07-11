module ctfe;

bool isPrime(int n)
{
    if (n == 2)
        return true;
    if (n < 1 || (n & 1) == 0)
        return false;
    if (n > 3)
    {
        for (auto i = 3; i * i <= n; i += 2)
            if ((n % i) == 0)
                return false;
    }
    return true;
}

unittest
{
    import std.stdio : writeln;

    // `static assert` is an `assert` evaluated by the compiler.
    static assert(isPrime(2));
    static assert(!isPrime(42));
}

unittest
{
    static if (isPrime(17))
        pragma(msg, "17 is prime!");

    static if (isPrime(10))
        pragma(msg, "10 is prime!");

    if (isPrime(20))
        pragma(msg, "20 is prime!... Wait, what?");
}

unittest
{
    static if (0)
        You_thought_this_was_going_to_cause_an_error_did_you_not;
}

unittest
{
    // TODO: uncomment the lines below, try to compile the code, then fix the
    // errors to make it compile.
    // int x = 10;
    // static assert ((x & 2) && isPrime(x));
}
