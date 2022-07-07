import std.stdio;

int add(int lhs, int rhs) nothrow
{
    writeln("adding");    //  compilation ERROR because writeln is not a `nothrow` function
    return lhs + rhs;
}

void main()
{
    add(1, 2);
}
