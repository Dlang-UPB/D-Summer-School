module template_functions;

import std.stdio : writeln;
import std.conv : to;

void fooNonTemplate(int x)
{
    writeln("foo: " ~ x.to!string);
}

void fooNonTemplate(double x)
{
    writeln("foo: " ~ x.to!string);
}

void fooNonTemplate(string x)
{
    writeln("foo: " ~ x);
}

unittest
{
    fooNonTemplate(11);
    fooNonTemplate(4.2);
    fooNonTemplate("hello");
}

void fooTemplate(T)(T x)
{
    writeln("foo: " ~ x.to!string);
}

unittest
{
    // TODO: uncomment the lines below and re-run `get_foo_symbols.sh`.
    // fooTemplate(1);
    // fooTemplate(0.42);
    // fooTemplate("world");
}
