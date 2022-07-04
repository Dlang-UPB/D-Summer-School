struct SRectangle
{
    size_t length, width;
    int id;

    size_t area() { return length*width; }
    size_t perimeter() { return 2*(length + width); }
    size_t isSquare() { return length == width; }
    void setId(int id) { this.id = id; }
}

class CRectangle
{
    size_t length, width;
    int id;

    size_t area() { return length*width; }
    size_t perimeter() { return 2*(length + width); }
    size_t isSquare() { return length == width; }
    void setId(int id) { this.id = id; }
}

void main()
{
    SRectangle sr = SRectangle(1, 2, 3);
    CRectangle cr = new CRectangle();
    cr.length = 2;
    cr.width = 3;
    cr.id = 4;

    auto sr2 = sr;
    auto cr2 = cr;

    sr2.length = 100;
    cr2.length = 101;

    import std.stdio : writeln;
    writeln(sr.length);
    writeln(sr2.length);
    writeln(cr.length);
    writeln(cr2.length);
}
