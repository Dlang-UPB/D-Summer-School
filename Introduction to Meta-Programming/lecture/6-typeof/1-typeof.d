module typeof_1;
import std.stdio;

void foo(int i)
{
    typeof(i) j;       // j is of type int
    typeof(3 + 6.0) x; // x is of type double
    typeof(1)* p;      // p is of type pointer to int
    int[typeof(p)] a;  // a is of type int[int*]

    writefln("%d", typeof('c').sizeof); // prints 1
    double c = cast(typeof(1.0))j; // cast j to double
}

void main(string[] args)
{
    foo(20);
}
