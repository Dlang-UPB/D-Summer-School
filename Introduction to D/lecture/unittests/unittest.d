import std.stdio : writeln;

struct Sum
{
    int add(int x, int y) { return x + y; }

    unittest
    {
        writeln("in unittest 1");
        Sum sum;
        assert(sum.add(3,4) == 7);
        assert(sum.add(-2,0) == -2);
    }
}

unittest
{
    asdsdf
    int a "asd";
    writeln("in unittest 2");
}

void main()
{
    writeln("in main");
}
