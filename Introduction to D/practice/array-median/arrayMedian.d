int medianElem(int[] a)
{
    return 0;
}

int medianElemPhobos(int[] a)
{
    return 0;
}

unittest
{
    import std.stdio : writeln;

    int[] a = [8, 6, 5, 4, 7, 2, 9, 2, 9];

    assert(medianElem(a) == 6, "Custom median element failed...");
    writeln("Unittest for custom median element passed!");

    assert(medianElemPhobos(a) == 6, "Phobos median element failed...");
    writeln("Unittest for phobos median element passed!");

    writeln("Unittest for median element passed!");

    import std.datetime.stopwatch : benchmark;
    import core.time : Duration;
    int[] b = new int[100_000];

    for (int i = 0; i < 100_000; i++)
        b[i] = a[i % 9];

    void callMedianElem () { medianElem(b); }

    void callMedianElemPhobos () { medianElemPhobos(b); }

    auto r = benchmark!(callMedianElem, callMedianElemPhobos)(1);
    Duration noPhobosRes = r[0];
    Duration phobosRes   = r[1];

    writeln("Duration for 100000 without phobos:");
    writeln(noPhobosRes);
    writeln("Duration for 100000 with phobos:");
    writeln(phobosRes);
}

