module template_constraints;

T sub(T)(T lhs, T rhs)
if (is(T == int) || is(T == real) || is(T == double))
{
    return lhs - rhs;
}

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

string returnIfPrimeTemplate(int num)()
if (isPrime(num))
{
    return "prime";
}

string returnIfPrimeParam(T)(T num)
if (isPrime(num))
{
    return "prime";
}

unittest
{    
    assert(1 == sub(2, 1));
    assert(1.2 - sub(1.5, 0.3) < 0.001);

    // `__traits(compiles, exp)` silently checks whether `exp` would compile or not
    assert(!__traits(compiles, sub("yes", "no")));
}

unittest
{
    assert("prime" == returnIfPrimeTemplate!17);
    assert(!__traits(compiles, returnIfPrimeTemplate!25));

    // TODO: Uncomment this `assert`.
    assert(!__traits(compiles, returnIfPrimeParam(17)));
    assert(!__traits(compiles, returnIfPrimeParam(25)));
}

void main() { }
