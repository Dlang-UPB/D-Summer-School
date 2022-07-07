import std.stdio;

struct VeryBigStruct { int a; }   // but still empty

void gun(VeryBigStruct* c) @safe
{
    // do whatever
}

void func(VeryBigStruct a) @safe
{
    gun(&a);
    writeln((&a.a)[2]);
}

void main()
{
    func(VeryBigStruct());
}
