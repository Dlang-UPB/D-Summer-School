import std.stdio : writefln;

void add(int a, int b)
{
    writefln("sum = %d", a + b);
}

void add(double a, double b)
{
    writefln("sum = %f", a + b);
}

void main()
{
    add(10, 2);
    add(5.3, 6.2);
}
