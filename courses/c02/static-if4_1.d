module static_if;

import std.stdio;

enum Square;
enum Rectangle;

struct Parallelogram(T)
{
    int length;

    static if(is(T == Rectangle))
    {
        int width;
        this(int length, int width)
        {
            this.length = length;
            this.width = width;
        }
    }
    else
    {
        this(int length)
        {
            this.length = length;
        }
    }
}

int foo(int N = 3)()
{
    static if (N == 0)
    {
        return 0;
    }
    else
    {
        return N + foo!(N - 1)();
    }
}

void main()
{
    pragma(msg, foo!());
    //auto x = Parallelogram!(Rectangle)(2, 5);
    //auto y = Parallelogram!(Square)(2);
    //writefln("%s %s", typeof(x).stringof, x);
    //writefln("%s %s", typeof(y).stringof, y);
}
