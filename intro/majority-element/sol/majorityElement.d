string majorityElement(string[] a)
in (a.length > 0)
{
    int[string] aa;
    int max = 0;
    string ans;

    foreach(string s; a)
    {
        aa[s]++;
        if (aa[s] > max)
        {
            max = aa[s];
            ans = s;
        }
    }

    return ans;
}

unittest
{
    import std.stdio : writeln;

    string[] a = ["dss", "foo", "dss", "bar", "asd"];
    assert(a.majorityElement() == "dss");

    writeln("Unittest passed!");
}

