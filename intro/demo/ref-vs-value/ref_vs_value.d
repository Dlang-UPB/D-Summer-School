void setLength(int[] a, size_t length)
{
    a.length = length;
}

void startWith2(int[] a)
{
    a[0] = 2;
    a[1] = 2;
}

void main()
{
    import std.stdio : writeln;
    int[] a = new int[5];
    
    a.setLength(2);
    a.startWith2();

    writeln(a);
}

