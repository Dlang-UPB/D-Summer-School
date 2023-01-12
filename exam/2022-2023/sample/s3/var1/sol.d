import std.stdio;
import core.stdc.stdlib;

struct S
{
    int x;
};

int main() @safe
{
    const int NUM_ELEMS = 10;
    S[NUM_ELEMS] myStructs;
    int i = 0;

    for (i = 0; i < NUM_ELEMS; ++i)
        myStructs[i].x = i;

    // Get last element
    S last = myStructs[NUM_ELEMS-1];
    writefln("Value of last elem is %d", last.x);

    return 0;
}
