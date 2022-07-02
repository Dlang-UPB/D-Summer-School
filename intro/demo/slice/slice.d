void main()
{
    import std.stdio : writeln;

    int[10] a;
    auto b = a[0 .. $];
    b = b ~ 5;

    writeln(b.length);
    writeln(a.length);
}