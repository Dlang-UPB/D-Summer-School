import std.stdio;
import core.stdc.stdlib;

struct S
{
    int x;
};

int main()
{
    const int NUM_ELEMS = 10;
    S* myStructs = malloc(NUM_ELEMS * S.sizeof);
    int i = 0;

    for (i = 0; i < NUM_ELEMS; ++i)
        myStructs[i].x = i;

    // Get last element
    S* last = myStructs + NUM_ELEMS;
    printf("Value of last elem is %d\n", last.x);

    return 0;
}
