int medianElem(int[] a)
{
    for (int i = 0; i < a.length; i++)
        for (int j = i + 1; j < a.length; j++)
            if (a[i] > a[j]) {
                int temp = a[i];
                a[i] = a[j];
                a[j] = temp;
            }

    for (int i = 0; i < a.length - 1; i++)
        if (a[i] == a[i + 1])
            a = a[0 .. i] ~ a[i + 1 .. $];

    if (a.length % 2 != 0)
        return a[a.length / 2];

    return (a[(a.length - 1) / 2] + a[a.length / 2]) / 2;
}

int medianElemPhobos(int[] a)
{
    import std.algorithm : sort;

    a.sort();

    for (int i = 0; i < a.length - 1; i++)
        if (a[i] == a[i + 1])
            a = a[0 .. i] ~ a[i + 1 .. $];

    if (a.length % 2 != 0)
        return a[a.length / 2];

    return (a[(a.length - 1) / 2] + a[a.length / 2]) / 2;
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

