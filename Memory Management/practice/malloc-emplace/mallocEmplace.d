struct Point {
    int x, y;

    this(int n, int m) {
        x = n;
        y = m;
    }
}

void main()
{
    import core.stdc.stdlib;
    import std.stdio;
    import core.lifetime : emplace;

    Point* thirdPoint = cast(Point*)malloc(Point.sizeof);
    thirdPoint = emplace!Point(thirdPoint, 2, 1);
    writeln(*thirdPoint); // prints Point(2, 1)
}
