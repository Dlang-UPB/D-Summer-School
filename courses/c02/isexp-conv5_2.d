module isexp_conv;

import std.stdio;

interface Clock
{
    void tellTime();
}

class AlarmClock : Clock
{
    override void tellTime()
    {
        writeln("10:00");
    }
}

void myFunction(T)(T parameter)
{
    // is (T : OtherT)
    // is (T Alias : OtherT)
    // is (T == Specifier)
    static if (is (T == Clock))
    {
        // If we are here then T can be used as a Clock
        writeln("This is a Clock; we can tell the time");
        parameter.tellTime();
    }
    else static if (is (T == AlarmClock))
    {
        // If we are here then T can be used as a Clock
        writeln("This is an AlarmClock; we can tell the time");
        parameter.tellTime();
    }
    else
    {
        writeln("This is not a Clock");
    }
}

void main()
{
    auto var = new AlarmClock;
    myFunction(var);
    myFunction(42);
}
