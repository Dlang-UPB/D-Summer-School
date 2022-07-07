import std.stdio;

extern(C) size_t read(int, void*, size_t);

void main()
{
    char[] a;
    a.length = 5;
    auto b = read(0, cast(void*)a, a.length);
    a[b-1] = '\0';
    writeln(a);
}
