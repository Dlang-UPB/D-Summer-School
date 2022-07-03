string majorityElement(string[] a)
in (a.length > 0)
{
    return "";
}

unittest
{
    import std.stdio : writeln;

    string[] a = ["dss", "foo", "dss", "bar", "asd"];
    assert(a.majorityElement() == "dss");

    writeln("Unittest passed!");
}

