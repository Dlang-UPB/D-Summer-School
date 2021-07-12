import std.stdio;

int sum(int a, int b)
{
    return a + b;
}

void main()
{
    enum a = 5;
    enum b = 7;
    enum c = sum(a, b);
    pragma(msg, "c = ", c);
    writeln(c);
}
