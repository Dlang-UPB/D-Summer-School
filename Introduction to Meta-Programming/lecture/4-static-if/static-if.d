moudle static_if;
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

void main()
{
    auto x = Parallelogram!(Rectangle)(2, 5);
    auto z = Parallelogram!(Square)(2);
}
